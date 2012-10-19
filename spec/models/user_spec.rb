require 'spec_helper'

describe User do
  context "on Valid data " do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it { should validate_presence_of(:email)}
    it { should validate_format_of(:email).to_allow("abc@xyz.com").not_to_allow("abc") }
    it { should validate_format_of(:email).to_allow("abc@xyz.in").not_to_allow("abc@") }
    it { should validate_format_of(:email).to_allow("abc@xyz.co.in").not_to_allow("abc@xyz") }
    it { should validate_format_of(:email).to_allow("abc@xyz.c").not_to_allow("abc@xyz.") }

    it "valid" do
      @user.save
      @user.should be_valid
    end
    it "name" do
      @user.name.should == "Sanjiv Kumar Jha"
    end
    
    it "first_name" do
      @user.first_name.should == "Sanjiv"
    end

    it "last_name" do
      @user.last_name.should == "Jha"
    end
    
    it "nickname" do
      @user.nickname.should == "sanjiv1212"
    end

    it "phone" do
      @user.phone.should == "123456789"
    end
  end

  context "on Invalid Data" do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "email" do
      @user.email = nil
      @user.save 

      @user.should_not be_valid
    end

    it "password" do 
      @user.password = nil
      @user.should_not be_valid
    end

    
  end
end
