require 'spec_helper'

describe Category do

  let(:category){Category.new()}
  it 'should have a name' do
    category.save
    category.should have(1).errors_on(:name)
  end
  
  it'should have a unique name' do
    Category.create(name: 'new')
    category.name='new'
    category.should have(1).errors_on(:name)
  end

end
