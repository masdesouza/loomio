# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    user_id 1
    address "MyString"
    comment_id 1
  end
end
