require 'spec_helper'

describe Chwink do
  
  let(:chwink){Chwink.new(name: "Mychwink", end_year: "2020", category_id: "0987654334", user_id: "6789eywghd")}
  
  context "Adding a new chwink" do
    it "should have a name" do
      chwink.name = nil
      expect(chwink).to have(1).errors_on(:name)
    end
    it "should have an end_year" do
      chwink.end_year = nil
      expect(chwink).to have(2).errors_on(:end_year)
    end
    it "should have year as integer of length 4" do
      chwink.end_year = "20202"
      expect(chwink).to have(1).errors_on(:end_year)
    end
    it "should have a category" do
      chwink.category_id = nil
      expect(chwink).to have(1).errors_on(:category_id)
    end
    it "should belong to a user" do 
      chwink.user_id = nil
      expect(chwink).to have(1).errors_on(:user_id)
    end
    it "should save valid object" do
      chwink.save
      chwink.should be_valid
    end
  end
  context "name keyword search" do
    it "should return similar chwinks based on name" do
      pending
      query = "Mychwink"
      chwinks1 = Chwink.similar(query)
      #p chwinks1
      #chwink.similar not returning an array of chwink objects instead returning mongoid mapreduce object
      chwinks1.first.save
      chwinks1.should_be valid
    end
    it "should return case-insensitive search" do
      pending
      query = "mychwink"
      chwinks1 = Chwink.similar(query)
      chwinks1.first.save
      chwinks1.should_be valid
    end

    it "should return empty Array if nothing is found" do
      pending
      query = "non-existent chwink"
      chwinks1 = Chwink.similar(query)
      chwinks1.first.save
      chwinks1.should_be not_valid
    end
  end

  context "ranking" do
    before :each do
      chwink.save
    end
    it "should increment the year ranking by 1 when a user agrees to the year" do
      chwink.vote(:up => "2020")
      expect(chwink.votes["2020"]).to eq(2)  
    end
    it "should decrement the year ranking by 1 if user changes his vote" do
      chwink.vote(:up => "2022", :down => "2020")
      expect(chwink.votes["2020"]).to eq(nil)  
    end
    it "should increment the year ranking by 1 when user changes his vote" do
      chwink.vote(:up => "2022", :down => "2020")
      expect(chwink.votes["2022"]).to eq(1)  
    end
    it "should add new year if the year doesn't exist" do
      chwink.vote(:up => "2030")
      expect(chwink.votes["2030"]).to eq(1)
    end
    it "should maintain ranking for all years added in descending order of votes" do
      3.times {chwink.vote(:up => "2011")}
      2.times {chwink.vote(:up => "2012")}
      5.times {chwink.vote(:up => "2013")}
      expect(chwink.ranking).to eq(["2013","2011","2012","2020"])
    end
  end

end
