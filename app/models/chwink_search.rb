class ChwinkSearch
  attr_accessor :params
  
  def initialize(params)
    self.params = params
  end
  
  def search
    query = params[:query]
    model.search(page: params[:page], per_page: 5) do
      query { string query, default_operator: "AND" } if query.present?
      #filter :range, published_at: { lte: Time.zone.now }
      sort { by :name } if query.blank?
    end
  end
  
  protected
  
  def model
    Chwink
  end
end

