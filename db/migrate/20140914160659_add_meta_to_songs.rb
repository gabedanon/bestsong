class AddMetaToSongs < ActiveRecord::Migration
  def change
  	add_column :songs, :spotify_id, :string
  	add_column :songs, :artist, :string
  	add_column :songs, :title, :string
  	add_column :songs, :album, :string
  	add_column :songs, :artwork_url, :string
  	add_column :songs, :preview_url, :string
  	add_column :songs, :vote_for, :integer
  	add_column :songs, :vote_against, :integer
  end
end
