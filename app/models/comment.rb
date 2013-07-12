class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  
  track_history on: [:comment], track_create: true, scope: :chwink 


  REVIEW = "Review"
  VOTE = "Vote"
  TYPES = [REVIEW, VOTE]

  field :type, type: String
  field :comment, type: String
  field :year, type: Integer

  belongs_to :chwink
  belongs_to :user

  scope :votes, where(:type => VOTE)
  scope :reviews, where(:type => REVIEW)
  scope :by_user, lambda { |user| where(user: user) }

end
