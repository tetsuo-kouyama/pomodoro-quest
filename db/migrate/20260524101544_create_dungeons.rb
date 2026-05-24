class CreateDungeons < ActiveRecord::Migration[7.2]
  def change
    create_table :dungeons do |t|
      t.string :name, null: false
      t.integer :required_time, null: false, comment: "seconds"
      t.integer :difficulty, null: false
      t.integer :reward_gold, null: false

      t.timestamps
    end
  end
end
