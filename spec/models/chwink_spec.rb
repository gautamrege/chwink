require 'spec_helper'

describe Chwink do
  
  let(:chwink){Chwink.new(name: "Mychwink", end_year: "2020", category_id: "0987654334", user_id: "6789eywghd")}
  
  context "Adding a new chwink" do
    it "should have a name" do
      chwink.name = nil
      chwink.save
      chwink.should_not be_valid
    end
    it "should have an end_year" do
      chwink.end_year = nil
      chwink.save
      chwink.should_not be_valid
    end
    it "should have year as integer of length 4" do
      chwink.end_year = "20202"
      chwink.save
      chwink.should_not be_valid
    end
    it "should have a category" do
      chwink.category_id = nil
      chwink.save
      chwink.should_not be_valid
    end
    it "should belong to a user" do 
      chwink.user_id = nil
      chwink.save
      chwink.should_not be_valid
    end
    it "should have a slug name" do
      chwink._slugs = nil
      chwink.save
      chwink.should_not be_valid
    end
  end
  context "name keyword search" do
    it "should return similar chwinks based on name" do
      query = "Mychwink"
      chwinks1 = Chwink.similar(query)
      #p chwinks1
      #chwink.similar not returning an array of chwink objects instead returning mongoid mapreduce object
      chwinks1.first.save
      chwinks1.should_be valid
    end
    it "should return case-insensitive search" do
      query = "mychwink"
      chwinks1 = Chwink.similar(query)
      chwinks1.first.save
      chwinks1.should_be valid
    end

    it "should not search with stopwords" 
      #Results for "mychwink" should be same as "these are like mychwinks"
    
    it "should return empty Array if nothing is found" do
      query = "non-existent chwink"
      chwinks1 = Chwink.similar(query)
      chwinks1.first.save
      chwinks1.should_be not_valid
    end
  end

  context "similar chwinks" do
     it "should show similar chwinks on selection" 
     it "not select itself as similar chwink"
     it "should not have remnant M/R collections"
  end

  context "ranking" do
     it "should increment the year ranking by 1 when a user agrees to the year" do
     #  chwink.vote("2020")
     end
     "should decrement the year ranking by 1 and increment other year by 1 if user changes his rank"
     "should add new year if the year doesn't exist"
     "should maintain ranking for all years added"
     "should have top 5 ranks stored, not calculated"
     "should have top rank stored, not calculated"
     "should verify changes in year ranking after every update"
  end

end
