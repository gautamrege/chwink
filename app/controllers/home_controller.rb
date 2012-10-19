class HomeController < ApplicationController
  def index
    @chwinks = [Chwink.new(:name => 'Test', :end_year => 2001, :description => 'Description comes here as well goes there and come here and soon to test the very long description which can move the like button very low so that i will get hidden')]#Chwink.all
  end
end
