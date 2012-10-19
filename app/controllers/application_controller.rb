class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_for_action
  before_filter :get_categories

  def check_for_action
    @to_be_broadcast = false
    @broadcast_data = {}
    if session[:action] 
      @to_be_broadcast = true
      @broadcast_data = {action: session[:action], user: User.where(id: session[:user_id]).first.try(:nickname), chwink: Chwink.where(id: session[:chwink_id]).first.try(:name)}.to_json      
      session[:action] = session[:user_id] = session[:chwink_id] = nil
    end
    @broadcast_data = @broadcast_data.as_json
  end

  def get_categories
    @categories = []#Category.all
  end

  def login_required
    if !current_user
      respond_to do |format|
        format.js {
          render :js => "window.location.href='#{HOST_URL}auth/twitter'"
        }
        format.html  {
          redirect_to '/auth/twitter'
        }
        format.json {
          render :json => { 'error' => 'Access Denied' }.to_json
        }
      end
    end
  end
end
