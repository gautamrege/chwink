FactoryGirl.define do
  factory :user do|u|
    u.sequence(:email) { |n| "kapil#{n}@joshsoftware.com"}
    u.name "Sanjiv Kumar Jha"
    u.first_name "Sanjiv"
    u.last_name "Jha"
    u.nickname "sanjiv1212"
    u.location "pune"
    u.phone "123456789"
    u.password "sanjiv123"
    u.password_confirmation "sanjiv123"
  end
end
