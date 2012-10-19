class AuthenticationsController < ApplicationController
  def create 
    omniauth = auth # Do what you want with the auth hash!
    authentication = Authentication.where(provider: omniauth['provider'], uid: omniauth['uid']).first
    user = nil    
    if authentication
      if authentication.user.blank?
        user = create_new_omniauth_user(omniauth)    
        authentication.user = user
        authentication.save!
      end
      user = authentication.user
      flash[:notice] = "Signed Succefully"
      sign_in(user)  
    else
      auth = Authentication.create(provider: omniauth[:provider], uid: omniauth[:uid], token: omniauth[:credentials][:token], secret: omniauth[:credentials][:secret]) 
      user = create_new_omniauth_user(omniauth)
      if user
        auth.user = user
        auth.save!
        flash[:notice] = "Signed Succefully"
        sign_in(user)  
      end
      flash[:notice] = "Signed Succefully"
    end
     
    redirect_to request.env["HTTP_REFERER"] || root_url   
  end

  def failure 
    flash[:error] = params[:message]
    redirect_to root_url
  end

  def auth; request.env['omniauth.auth'] end

  def create_new_omniauth_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth)
    if user.save!
      return user
    else
      nil
    end
  end
end
