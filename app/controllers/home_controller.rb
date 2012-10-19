class HomeController < ApplicationController
  def index
    @chwinks = Chwink.all 
  end
end
