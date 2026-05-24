FactoryBot.define do
  factory :dungeon do
    name { "MyString" }
    required_time { 1 }
    difficulty { 1 }
    reward_gold { 1 }
  end
end
