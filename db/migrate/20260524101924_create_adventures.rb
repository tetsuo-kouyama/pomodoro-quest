class CreateAdventures < ActiveRecord::Migration[7.2]
  def change
    create_table :adventures do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dungeon, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :status, null: false, default: 0
      t.integer :reward_gold, null: false

      t.timestamps
    end
  end
end
