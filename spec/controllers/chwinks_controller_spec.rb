require 'spec_helper'

describe ChwinksController do
  include Devise::TestHelpers
  
  before do
    request.env["devise.mapping"] = Devise.mappings[:user] 

    OmniAuth.config.add_mock(:twitter, {provider: "twitter", uid: "1234", 
                                      info: {name: "Bob hope", nickname: "bobby"},
                                      credentials: { token: "lk2j3lkjasldkjflk3ljsdf", secret: "1213434asdsdqwqwsqww"} })
    
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    visit '/auth/twitter' 
    @user = User.last
  end
  
  before(:each) do
    Category.create(name: 'Daily') 
    Category.create(name: 'Transport')
    Category.create(name: 'Living')
    Category.first.chwinks.create!(name: "water", user_id: @user.id, end_year: "2100")
    Category.last.chwinks.create(name: "tiger", user_id: @user.id, end_year: "2020")
    Category.last.chwinks.create(name: "dolphin", user_id: @user.id, end_year: "2020")
  end

  describe 'GET #index' do
    it 'must redirect to home on invalid search' do
      get :index, query: 'abcd'
      expect(response).to redirect_to root_path 
    end

    it 'must show all the chwinks for blank search' do
      get :index, query: ''
      expect(assigns(:count_chwinks)).to equal(3)
      expect(response).to render_template :index
    end

    it 'must show the chwink for valid search' do
      get :index, query: 'water'
      expect(assigns(:count_chwinks)).to equal(1)
      expect(response).to render_template :index
    end

    it 'must show the chwink for valid category if not empty' do
      get :index, category_id: Category.last.id
      expect(assigns(:count_chwinks)).to equal(2)
      expect(response).to render_template :index
    end
    
    it 'should redirect to home if category is empty' do
      get :index, category_id: Category.where(name: 'Transport').first
      expect(assigns(:count_chwinks)).to equal(0)
      expect(response).to redirect_to root_path
    end

  end

end
