class CreateOwnedMonsters < ActiveRecord::Migration[7.2]
  def change
    create_table :owned_monsters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :monster, null: false, foreign_key: true
      t.string :nickname
      t.integer :level, null: false, default: 1
      t.boolean :active, null: false, default: false
      t.integer :party_position

      t.timestamps
    end
  end
end
