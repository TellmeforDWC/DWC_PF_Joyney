class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|

      t.string "spot_name"
      t.string "image_id"
      t.float  "longitude"
      t.float  "latitude"

      t.timestamps
    end

    add_index :spots, "spot_name"

  end
end