class AddDurationToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :duration, :integer
  end
end
