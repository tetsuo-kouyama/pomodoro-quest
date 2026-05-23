FactoryBot.define do
  factory :owned_monster do
    association :user
    association :monster

    nickname { "test" }
    level { 1 }
    active { false }
    party_position { 1 }
  end
end
