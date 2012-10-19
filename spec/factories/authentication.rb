FactoryGirl.define do
  factory :authentication do|auth|
    auth.sequence(:uid) {|n| 10 + Random.rand(100000000)}
    auth.provider 'twitter'
  end
end
