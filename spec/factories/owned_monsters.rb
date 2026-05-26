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

    trait :party_member do
      active { true }
      sequence(:party_position) do |n|
        ((n - 1) % OwnedMonster::MAX_PARTY_SIZE) + 1
      end
    end
  end
end
