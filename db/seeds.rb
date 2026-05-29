# ==========================================
# 1. 本番・開発共通の「マスターデータ」（モンスター定義）
# ==========================================

monsters = [
  {
    id: 1,
    name: 'スライム',
    base_hp: 10,
    base_atk: 3,
    base_def: 1,
    hire_cost: 50
  },
  {
    id: 2,
    name: 'ゴブリン',
    base_hp: 25,
    base_atk: 7,
    base_def: 3,
    hire_cost: 100
  }
]

monsters.each do |monster_data|
  monster = Monster.find_or_initialize_by(id: monster_data[:id])
  monster.update!(monster_data)
end
puts "🌱 Monster seed data loaded successfully! (Total: #{Monster.count})"

# ==========================================
# 2. 本番・開発共通の「マスターデータ」（ダンジョン定義）
# ==========================================

dungeons = [
  {
    id: 1,
    name: 'スライムの洞窟',
    difficulty: 1,
    reward_gold: 100
  },
  {
    id: 2,
    name: 'ゴブリンの森',
    difficulty: 3,
    reward_gold: 300
  }
]

dungeons.each do |dungeon_data|
  dungeon = Dungeon.find_or_initialize_by(id: dungeon_data[:id])
  dungeon.update!(dungeon_data)
end
puts "🏰 Dungeon seed data loaded successfully! (Total: #{Dungeon.count})"
