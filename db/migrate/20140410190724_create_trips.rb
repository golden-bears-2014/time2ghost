class CreateTrips < ActiveRecord::Migration
  def change
    create_table :bart_trips do |t|
      t.belongs_to :user
      t.string :departure_station
      t.string :destination_station
      t.string :current_location
      t.integer :walking_time
      t.text :directions
      t.datetime :train_departing_time
      t.datetime :recommended_leave_time
      t.string :bart_line
      t.timestamps
    end
  end
end
