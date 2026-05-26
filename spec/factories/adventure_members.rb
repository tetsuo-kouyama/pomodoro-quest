FactoryBot.define do
  factory :adventure_member do
    association :owned_monster
    association :adventure

    sequence(:slot) { |n| n }
  end
end
