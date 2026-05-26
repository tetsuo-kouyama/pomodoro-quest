FactoryBot.define do
  factory :adventure do
    association :user
    association :dungeon

    required_time { 25.minutes }
    reward_gold { 100 }
    start_at { Time.current }
    end_at { start_at + required_time }
    status { :pending }

    trait :ongoing do
      status { :ongoing }
    end

    trait :finished do
      status { :finished }
    end

    trait :claimed do
      status { :claimed }
    end

    trait :with_members do
      after(:create) do |adventure|
        monsters = create_list(:owned_monster, 5, :party_member, user: adventure.user)

        monsters.each do |monster|
          create(
            :adventure_member,
            adventure: adventure,
            owned_monster: monster,
            slot: monster.party_position
          )
        end
      end
    end
  end
end
