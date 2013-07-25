require 'eventmachine'
class Chwink
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paperclip
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  # history tracking all Chwink documents
  # note: tracking will not work until #track_history is invoked
  include Mongoid::History::Trackable
  track_history on: [:name, :description, :region, :culture, :end_year, :own_it], track_create: true, track_update: true, track_destroy: true  
  
  field :name, type: String
  field :description, type: String
  field :region, type: String
  field :culture, type: String
  field :end_year, type: Integer
  field :own_it, type: Boolean, default: true

  # increment fields
  field :votes, type: Hash # maintains the year-votes

  belongs_to :category
  belongs_to :user
  has_mongoid_attached_file :image, PAPERCLIP_CONFIG
  has_many :comments
  
  slug :name
  validates :name, :user_id, :category_id, presence: true
  validates :end_year, presence: true, length: { is: 4 }
  validates :name, uniqueness: true

  before_create do |record|
    record.votes = { record.end_year.to_s => 1 }
  end

  after_update do |record|
    user = User.where(id: record[:modifier_id]).first
    user_image =  "<img width='16px' height ='16px' class='user_image' src=#{user.try(:image)}" + "/>"
    modifier = user.blank? ? "Someone" : user.nickname
    modifier = user_image + modifier
    data = "<a href=/chwinks/#{record.id}> #{record.name}</a>"
    message = modifier + "updated" + data
    message = "<li class='activity'>" + message + "</li>"
    #EM.run {
    #  client = Faye::Client.new('http://localhost:9292/faye')
    #  client.publish('/activity/public', {message: message})
    #} 
  end 
=begin
  STOPWORDS = %w(a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather said say says she should since so some than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your) 

  def similar
    Chwink.similar(self.name)
  end

  def self.similar(name)
    search = name.downcase.split(/\W/) - STOPWORDS

    # THE correct regular expression is always returning false. MongoDB 
    # is screwing around!
    #if (new RegExp("\\b" + value + "\\b").test(chwink.name) ) {
    map = %Q{ function() {    
        score = 0;     
        compare = #{search};
        chwink = this;
        compare.forEach(function(value) {
          if(chwink.name.toLowerCase().search(value) != -1) {
            score += 1;
          }
        });
        if (score > 0) {
          emit(score, { id: this._id.str, count: 1} );
        }   
      }
    }

    reduce = %q{ function( key, values) {
        res = { id: '', count: 0}
        values.forEach(function(value) {
          res.id = res.id + "," + value.id;
          res.count += value.count
        });
        return res;
      }
    }

    mr_collection = "#{SecureRandom.hex(4)}_similar"
    res = Chwink.map_reduce(map, reduce).out(replace: mr_collection)

    if res.empty?
      # Return if nothing found
      Chwink.collection.database[mr_collection].drop
      res # []
    else
      ## Fetch similar chwinks
      result = {}
      res.find().to_a.each { |e| result[e["_id"]] = e["value"] }
      result = result[result.keys.max]["id"].split(",").delete_if { |a| a == "" }
      Chwink.collection.database[mr_collection].drop
      Chwink.where(:id.in => result)
    end
  end
=end

  # self.votes is a Hash of { 2012 => 32, 2001 => 3 }
  #
  # params: 
  # votes: A hash containing :up and optionally :down
  # example:
  # { :up => 2012 }                => agree or new
  # { :up => 2012, :down => 1989 } => change
#
# REMEMEBER: MongoDB saves keys as STRINGS, so even if we are setting the
# key as an integer in Ruby, its getting saved as a string in MongoDB. So
# when its retrieved, be sure to convert the key back to an Integer!
# - Got fucked on this - so wrote it down for posterity and converted the
# the keys to strings!!
#
  def vote(year)
    self.votes = {} unless self.votes  # for old data (TO BE DELETED)

    # Add new vote or increment existing vote
    self.votes[year[:up]] = (self.votes[year[:up]].to_i || 0 ) + 1 if year[:up]

    if year[:down]
      # *ideally* there should never be a case where :down is sent and the key is
      # not presentI
      self.votes[year[:down]] = self.votes[year[:down]].to_i - 1
      # delete this if count is 0 
      self.votes.delete(year[:down]) if self.votes[year[:down]].to_i == 0
    end
    self.save(validate: false) # don't validate for speed
  end

  # Calculates at run-time, the ranking of the year and returns top 5 by default
  def ranking(limit=4)
    return [] unless self.votes ## empty array if no ranks
    self.votes.map.sort {|x, y| y[1] <=> x[1] }.collect {|y| y[0] }[0..limit]
  end


  def get_user_selection(user)
    self.comments.votes.by_user(user).first.year.to_s rescue nil
  end
   

  #SETTINGS and MAPPING for elasticsearch
  index_name "chwink_#{Rails.env}"  

  settings  analysis: {
              filter: {
                chwink_ngram: {
                  type: "edgeNgram",
                  max_gram: 15,
                  min_gram: 2
                },
                my_stemmer: {
                  type: "stemmer",
                  name: "english"
                }
              },
              analyzer: {
                index_ngram_analyzer: {
                  type: "custom",
                  tokenizer: "standard",
                  filter: ["chwink_ngram","standard","lowercase"]
                },
                  search_ngram_analyzer: {
                    type: "custom",
                    tokenizer: "standard",
                    filter: ["standard","lowercase","my_stemmer"]
                }
              }
            } do 
        mapping 
              indexes :name, type: 'multi_field', fields: {
                name: {type: "string",analyzer: "search_ngram_analyzer"},
                autocomplete: {
                  search_analyzer: "search_ngram_analyzer", 
                  index_analyzer: "index_ngram_analyzer",
                  type: "string"
                } 
              }
              indexes :description, type: 'string', analyser: "search_ngram_analyzer"
    end
=begin
      settings analysis: {
                  analyzer: {
                    default: {
                      type: 'snowball'
                    }  
                  }
                } do
      mapping {
        indexes :name, analyzer: "snowball"
        indexes :description, analyser: "snowball"
      }
    end
=end
  
  #Search function
  def self.search(query)
    tire.search(load: true) do
      #query {string 'name:' + query }
      query do
        boolean do
          should {string "name:#{query}" }
          should {string "description:#{query}"}
        end
      end
    end
  end

  def self.autocomplete(query)
    tire.search(load: true) do
      #query {string 'name.autocomplete:' + query }
      query do
        boolean do
          should {string "name.autocomplete:#{query}" }
          should {string "description:#{query}"}
        end
      end
    end
  end

end
