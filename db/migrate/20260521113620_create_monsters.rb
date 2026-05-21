class CreateMonsters < ActiveRecord::Migration[7.2]
  def change
    create_table :monsters do |t|
      t.string :name, null: false
      t.integer :base_hp, null: false
      t.integer :base_atk, null: false
      t.integer :base_def, null: false
      t.integer :hire_cost, null: false

      t.timestamps
    end
  end
end
