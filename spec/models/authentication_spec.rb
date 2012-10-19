require 'spec_helper'

describe Authentication do
 
  context "enter valid data " do 
    before(:each) do
      @user = FactoryGirl.create(:user)
      @auth = FactoryGirl.create(:authentication)
      @auth.user = @user
      @auth.save
    end
   
    it "should be valid" do
      @user.should be_valid
      @auth.should be_valid  
    end 
  
    it "should validates presence of uid" do
      should validate_presence_of(:uid)  
    end

    it "should validates presence of provider" do
      should validate_presence_of(:provider)  
    end

    it "should have user associated with it" do
      @auth.user.should == @user
    end
  end

  context "Invalid data" do
    before(:each) do
      @auth = FactoryGirl.create(:authentication)
    end

    it "invalid uid " do
      @auth.uid = nil
      @auth.save

      @auth.should_not be_valid
    end

    it "invalid provider" do
      @auth.provider = nil
      @auth.save

      @auth.should_not be_valid 
    end

    
  end
end
