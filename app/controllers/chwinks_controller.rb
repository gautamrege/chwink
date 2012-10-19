class ChwinksController < ApplicationController
  include ChwinksHelper
  before_filter :login_required, :only => [:vote, :create, :comment]

  def index
    @chwink = Chwink.new
    @slide_index = 0
    @chwinks = {"timeline" =>{"date" => []}}
    if params[:query].blank? and params[:category_id].blank? and params[:id].blank?
      chwinks = Chwink.all
    elsif !params[:query].blank?
      chwinks = Chwink.similar(params[:query])
    elsif !params[:category_id].blank?
      category = Category.find(params[:category_id])
      chwinks = category.chwinks
    elsif !params[:id].blank?
      first = Chwink.find(params[:id])
      chwinks = Chwink.similar(first.name)
    end
    chwinks.each do |chwink|
      facebook_url = "#{FACEBOOK_SHARE_URL}#{HOST_URL}chwinks/#{chwink.slug}"
      twitter_url = "#{TWITTER_SHARE_URL}#{chwink.name} #{HOST_URL}chwinks/#{chwink.slug}"
      hash ={"startDate" => chwink.ranking.first.to_s, 
            "endDate" => chwink.ranking.first.to_s, 
            "headline" => chwink.name, 
            "text" => chwink.description, 
            "slug" => chwink.slug, 
            "asset" => {
              "media" => chwink.image.url(:small), 
              "thumbnail" => chwink.image.url(:thumb), 
              "caption" => chwink.category.name, 
              "credit" => chwink.user.try(:name), 
              "type" => "image", 
              "user_image" => chwink.user.try(:image), 
              "facebook_link" => facebook_url, 
              "twitter_link" => twitter_url
            },
            "votes" => {
              "ranking" => chwink.ranking,
              # give it a shot - if users selection is ranked, show it ;)
              "selected" => chwink.get_user_selection(current_user)
            }
      } 
      @chwinks["timeline"]["date"] << hash
    end
    first = chwinks.first if first.blank?
    facebook_url = "#{FACEBOOK_SHARE_URL}#{HOST_URL}chwinks/#{first.slug}"
    twitter_url = "#{TWITTER_SHARE_URL}#{first.name}#{HOST_URL}chwinks/#{first.slug}"
    #@chwinks["timeline"]["headline"] = first.name
    @chwinks["timeline"]["type"] = "default"
    #@chwinks["timeline"]["text"] = first.description
    @chwinks["timeline"]["startDate"] = first.ranking.first.to_s
    @chwinks["timeline"]["slug"] = first.slug
    @chwinks["timeline"]["votes"] = { "ranking" => first.ranking } 
    @chwinks["timeline"]["asset"] = {"media" => first.image.url(:small), 
                              "thumbnail" => first.image.url(:thumb), 
                              "caption" => first.category.name, 
                              "credit" => first.user.try(:name), 
                              "type" => "image", 
                              "user_image" => first.user.try(:image), 
                              "facebook_link" => facebook_url, 
                              "twitter_link" => twitter_url}
    @chwinks = @chwinks.to_json
  end

  def show
    redirect_to chwinks_path(:id => params[:id])
  end

  def create
    @chwink = Chwink.new(params[:chwink])
    @chwink.user = current_user
    @chwink.save
    if @chwink.errors.any?
      flash[:notice] = "Chwink added successfully"
    else
      flash[:errors] = "some error occured while adding chwink"
    end
    session[:action] = "create"
    session[:user_id] = current_user.id
    session[:chwink_id] = @chwink._id
    redirect_to chwinks_url(:id => @chwink.slug)
  end

  def get_recent_activity
    @latest_activity = {recent_activity: {data: []}}
    ActivityTracker.all.order_by(created_at: :desc).limit(5).each do|actv|
      hsh = {message: build_activity_logs(actv) }
      @latest_activity[:recent_activity][:data] << hsh      
    end unless ActivityTracker.where('association_chain.name' =>  "Chwink").first.blank?
    @recent_activity = @latest_activity.to_json
    
    render json: @recent_activity 
  end

  def comment
    comment = Comment.new(params[:comment])
    chwink = Chwink.find(params[:chwink_id])
    comment.chwink = chwink
    comment.user = current_user
    comment.save

    render :json => {:nickname => current_user.nickname, :chwink_id => chwink.slug, :chwink_name => chwink.name}
  end

  def vote
    # Check if user has already voted for this chwink.
    chwink = Chwink.find(params[:chwink_id])

    if chwink.comments and (@vote = chwink.comments.votes.by_user(current_user).first)
      chwink.vote(:up => params[:year], :down => @vote.year.to_s)
      @vote.year = params[:year]
      @vote.save
    else
      @vote = chwink.comments.create(user: current_user, type: Comment::VOTE, year: params[:year].to_i)
      chwink.vote(:up => params[:year])
    end
  end
end
