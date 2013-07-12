require 'spec_helper'

describe Comment do
  let(:newcomment){Comment.new(type:'checking',comment:'new comment',year: '2013')}
  
  it 'must have a comment' do
    newcomment.comment = nil
    newcomment.save
    newcomment.should have(1).errors_on(:comment)
  end

end
