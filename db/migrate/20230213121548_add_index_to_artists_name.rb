class AddIndexToArtistsName < ActiveRecord::Migration[7.0]
  def change
    add_index :artists, :name
  end
end
