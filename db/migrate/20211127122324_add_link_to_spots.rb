class AddLinkToSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :link, :string
  end
end
