class RemoveColorFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :color
  end
end
