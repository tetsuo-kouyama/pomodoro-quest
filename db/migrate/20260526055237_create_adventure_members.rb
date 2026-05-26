class CreateAdventureMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :adventure_members do |t|
      t.references :owned_monster, null: false, foreign_key: true
      t.references :adventure, null: false, foreign_key: true
      t.integer :slot, null: false

      t.timestamps
    end
    add_index :adventure_members, [:adventure_id, :owned_monster_id], unique: true
  end
end
