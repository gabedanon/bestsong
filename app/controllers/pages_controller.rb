class PagesController < ApplicationController
	before_action :signed_in_user, only: [:autopopulate]
	def index
		# Fetch all songs, reorder them randomly, then grab the first two.
		@songs = Song.all.shuffle.first(2)
		# Make variable for the first of those two songs
		@song1 = @songs.first
		# Make variable for the last of those two songs
		@song2 = @songs.last
	end

	def results
		@song1 = Song.find(params[:song1])
		@song2 = Song.find(params[:song2])
		@winner = params[:winner]
		@votes = Vote.all
		@votes_for_1 = @votes.where(:for_id => params[:song1]).count
  		@votes_against_1 = @votes.where(:against_id => params[:song1]).count
  		total_votes_1 = @votes_for_1.to_f + @votes_against_1.to_f
  		@percentage_1 = ((@votes_for_1.to_f / total_votes_1) * 100).to_i
  		@votes_for_2 = @votes.where(:for_id => params[:song2]).count
  		@votes_against_2 = @votes.where(:against_id => params[:song2]).count
  		total_votes_2 = @votes_for_2.to_f + @votes_against_2.to_f
  		@percentage_2 = ((@votes_for_2.to_f / total_votes_2) * 100).to_i
	end

	def autopopulate
		song_array = []
		if params[:by] == 'gabe'
			song_array = ['3sSWmVU1hzjECM0sWPN95B','3eouHjHUIqm6RYZSqMwWKt','3jd3nPQtwKS3HY6A8XpXx5','4HlUH6aA6XyYvGZUO9HHHB','2MociE3KbbqAVoFWcEZsrD','3vA3kv3NDvOpFQA3bFkGbw','0DULl8SJbrfd337JKdFj4p']
		elsif params[:by] == 'most_streamed'
			charturl = 'http://charts.spotify.com/api/tracks/most_streamed/us/weekly/latest'
			r = HTTParty.get(charturl)
			r['tracks'].each do |t|
				t_id = t['track_url'].gsub(/(.)*\//, '')
				song_array << t_id
			end
		elsif params[:by] == 'most_viral'
			charturl = 'http://charts.spotify.com/api/tracks/most_viral/us/weekly/latest'
			r = HTTParty.get(charturl)
			r['tracks'].each do |t|
				t_id = t['track_url'].gsub(/(.)*\//, '')
				song_array << t_id
			end
		end
		v = 0
		nv = 0
		song_array.each do |song|
			url = 'https://api.spotify.com/v1/tracks/' + song
			resp = HTTParty.get(url)
			artist = resp['artists'][0]['name']
			title = resp['name']
			album = resp['album']['name']
			artwork_url = resp['album']['images'][1]['url']
			preview_url = resp['preview_url']
			newsong = current_user.songs.build(:spotify_id => song, :artist => artist, :title => title, :album => album, :artwork_url => artwork_url, :preview_url => preview_url)
			if newsong.valid?
				v += 1
			else
				nv += 1
			end
			newsong.save
		end
		flash[:success] = v.to_s + ' songs have been added to BSW (' + nv.to_s + ' unsuccessful).'
		redirect_to songs_path
	end

	def playlist
		url = params['playlist']
		dirs = url.split('/')
		user = dirs[4]
		playlist_id = dirs[6]
		RSpotify.authenticate("8c81e68dfc0e4b6ca8a3ed2294be2eaf", "bf4f66eb93644946bd7a0751b46950b4")
		playlist = RSpotify::Playlist.find(user, playlist_id)
		v = 0
		nv = 0
		standard_user = User.find_by(email: "gabe@duckbrigade.com")
		playlist.tracks.each do |song|
			song_id = song.id
			artist = song.artists.first.name
			title = song.name
			album = song.album.name
			artwork_url =  song.album.images[1]['url']
			preview_url = song.preview_url
			newsong = standard_user.songs.build(:spotify_id => song_id, :artist => artist, :title => title, :album => album, :artwork_url => artwork_url, :preview_url => preview_url)
			if newsong.valid?
				v += 1
			else
				nv += 1
			end
			newsong.save
		end
		flash[:success] = v.to_s + ' songs have been added to BSW (' + nv.to_s + ' unsuccessful).'
		redirect_to new_song_path
	end

	def add_votes
		10000.times do
			standard_user = User.find_by(email: "gabe@duckbrigade.com")
			# Fetch all songs, reorder them randomly, then grab the first two.
			@songs = Song.all.shuffle.first(2)
			# Make variable for the first of those two songs
			@song1 = @songs.first
			# Make variable for the last of those two songs
			@song2 = @songs.last
			newvote = Vote.new(:for_id => @song1.id, :against_id => @song2.id)
			newvote.save
		end
		redirect_to songs_path
	end
end
