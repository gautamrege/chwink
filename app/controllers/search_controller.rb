class SearchController < ApplicationController
  def index
    @chwinks = ChwinkSearch.new(params).search 
  end
end
