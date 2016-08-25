class AddCycleDependentToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :cycle_dependent, :boolean
  end
end
