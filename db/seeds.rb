# ==========================================
# 1. 本番・開発共通の「マスターデータ」（モンスター定義）
# ==========================================

# 古いモンスターデータをリセット
Monster.destroy_all

# モンスターデータを投入
Monster.create!([
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
])
