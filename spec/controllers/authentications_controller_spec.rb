require 'spec_helper'

describe AuthenticationsController do
  include Devise::TestHelpers
  
  before do
    request.env["devise.mapping"] = Devise.mappings[:user] 

    OmniAuth.config.add_mock(:twitter, {provider: "twitter", uid: "1234", 
                                      info: {name: "Bob hope", nickname: "bobby"},
                                      credentials: { token: "lk2j3lkjasldkjflk3ljsdf", secret: "1213434asdsdqwqwsqww"} })
    
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end 

  context "Validates authentication" do
    
    it "should increse authentication count" do
      lambda do
        get :create, :provider => "twitter"
      end.should change(Authentication, :count).by(1)
    end

    it "should increse User count" do
      lambda do
        get :create, :provider => "twitter"
      end.should change(User, :count).by(1)
    end

    it "should contain valid email" do
      get :create, :provider => "twitter"
      omni_auth = request.env["omniauth.auth"]
      auth = Authentication.find_by(uid: omni_auth[:uid])
      user = auth.user
      
      user.email.should == omni_auth[:info][:nickname] + '@custom_twitter.com'      
    end 
  end  
end
