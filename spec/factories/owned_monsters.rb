FactoryBot.define do
  factory :owned_monster do
    association :user
    association :monster

    sequence(:nickname) { |n| "name#{n}" }
    level { 1 }
    active { false }
    party_position { nil }

    trait :active do
      active { true }
    end
  end
end
