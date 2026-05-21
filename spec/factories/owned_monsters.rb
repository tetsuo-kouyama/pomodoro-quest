FactoryBot.define do
  factory :owned_monster do
    user { nil }
    monster { nil }
    level { 1 }
    active { false }
    party_position { 1 }
  end
end
