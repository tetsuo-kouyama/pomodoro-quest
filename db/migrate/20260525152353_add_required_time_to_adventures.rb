class AddRequiredTimeToAdventures < ActiveRecord::Migration[7.2]
  def change
    add_column :adventures, :required_time, :integer, null: false, comment: "seconds"
  end
end
