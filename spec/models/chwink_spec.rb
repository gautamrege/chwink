require 'spec_helper'

describe Chwink do
  pending "add some examples to (or delete) #{__FILE__}"

  context "name keyword search" do
    do "should return similar chwinks based on name"
    do "should return case-insensitive search"
    do "should not search with stopwords"
    do "should return empty Array if nothing is found"
  end

  context "similar chwinks" do
    do "should show similar chwinks on selection"
    do "not select itself as similar chwink"
    do "should not have remnant M/R collections"
  end

  context "ranking" do
    do "should increment the year ranking by 1 when a user agrees to the year"
    do "should decrement the year ranking by 1 and increment other year by 1 if user changes his rank"
    do "should add new year if the year doesn't exist"
    do "should maintain ranking for all years added"
    do "should have top 5 ranks stored, not calculated"
    do "should have top rank stored, not calculated"
    do "should verify changes in year ranking after every update"
  end

end
