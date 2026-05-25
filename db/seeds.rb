# ==========================================
# 1. 本番・開発共通の「マスターデータ」（モンスター定義）
# ==========================================

monsters = [
  {
    name: 'スライム',
    base_hp: 10,
    base_atk: 3,
    base_def: 1,
    hire_cost: 50
  },
  {
    name: 'ゴブリン',
    base_hp: 25,
    base_atk: 7,
    base_def: 3,
    hire_cost: 100
  },
  {
    name: 'オーク',
    base_hp: 80,
    base_atk: 15,
    base_def: 8,
    hire_cost: 300
  }
]

monsters.each do |monster|
  Monster.find_or_initialize_by(name: monster[:name])
         .update!(monster)
end

# ==========================================
#  2. 本番・開発共通の「マスターデータ」（ダンジョン定義）
# ==========================================

dungeons = [
  {
    name: "スライムの洞窟",
    difficulty: 1,
    reward_gold: 100
  },
  {
    name: "ゴブリンの森",
    difficulty: 2,
    reward_gold: 300
  }
]

dungeons.each do |dungeon|
  Dungeon.find_or_initialize_by(name: dungeon[:name])
         .update!(dungeon)
end
