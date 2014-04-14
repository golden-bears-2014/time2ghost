class CreateStations < ActiveRecord::Migration
def change
    create_table :stations do |t|
      t.string :abbr # No defaults?  No constraints?  :(  We know abbr to be 4 characters, by default postgres allocated 256.  So.  Uh.  Yeah.  Overkill.
      t.string :name
      t.string :latitude  # probably a decimal format ?
      t.string :longitude
      t.string :address
      t.string :city  # could also probably be constrained to a length as well
      t.string :state # 2 chars?
      t.string :zipcode # Probably an integer, and it's 5 characters or maybe 9 for the fine-grained version?
      t.timestamps
    end
  end
end
