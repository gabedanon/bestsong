class Song < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	before_validation { self.spotify_id = spotify_id.gsub(/(.)*\//, '') }
	validates :spotify_id, presence: true, length: { minimum: 1 }, uniqueness: true
	validates :user_id, presence: true
end