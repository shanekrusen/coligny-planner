class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.integer :day
      t.string :month
      t.integer :year
      t.time :start_time
      t.time :end_time
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :events, [:user_id, :month, :day, :year]
  end
end
