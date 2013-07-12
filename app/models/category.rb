class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  slug :name
  validates :name, presence: :true, uniqueness: :true
  has_many :chwinks
end
