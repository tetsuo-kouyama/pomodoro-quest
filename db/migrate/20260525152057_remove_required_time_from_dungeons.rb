class RemoveRequiredTimeFromDungeons < ActiveRecord::Migration[7.2]
  def change
    remove_column :dungeons, :required_time, :integer
  end
end
