module PartiesHelper
  def monster_in_slot(active_monsters, position)
    active_monsters.find do |monster|
      monster.party_position == position
    end
  end

  def total_party_power(monsters)
    monsters.sum(&:total_power)
  end
end
