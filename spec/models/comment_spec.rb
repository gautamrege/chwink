require 'spec_helper'

describe Comment do
  let(:newcomment){Comment.new(type:'checking',comment:'new comment',year: '2013')}
  
  it 'must have a comment' do
    newcomment.comment = nil
    newcomment.save
    newcomment.should have(1).errors_on(:comment)
  end

  it 'must have a type' do
    newcomment.type = nil
    newcomment.save
    newcomment.should have(1).errors_on(:type)
  end

  it 'must have a year' do
    newcomment.year = nil
    newcomment.save
    newcomment.should have(3).errors_on(:year)
  end

  it 'must have a valid year' do 
    newcomment.year = '2011'
    newcomment.save
    newcomment.should have(0).errors_on(:year)
  end

end
