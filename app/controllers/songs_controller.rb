class SongsController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :show]

	def index
		@songs = Song.all
		@votes = Vote.all
	end

	def new
		@song = Song.new
	end	
	
	def create
		standard_user = User.find_by(email: "gabe@duckbrigade.com")
		@song = standard_user.songs.build(song_params)
		if @song.save
			url = 'https://api.spotify.com/v1/tracks/' + @song.spotify_id
			resp = HTTParty.get(url)
			if resp['name']
				artist = resp['artists'][0]['name']
				title = resp['name']
				album = resp['album']['name']
				artwork_url = resp['album']['images'][1]['url']
				preview_url = resp['preview_url']
				@song.update_attributes(:artist => artist, :title => title, :album => album, :artwork_url => artwork_url, :preview_url => preview_url)
				flash[:success] = artist + ' - ' + title + ' has been added to BSW.'
			else
				flash[:danger] = 'Song could not be added'
				@song.destroy
			end
			redirect_to new_song_path
		else
			render 'new'
		end
	end

	def edit
		@song = Song.find(params[:id])
	end

	def update
		@song = Song.find(params[:id])

		if @song.update(song_params)
			redirect_to @song
		else
			render 'edit'
		end
	end
	
	def show
		@song = Song.find(params[:id])
	end

	def destroy
		@song = Song.find(params[:id])
		@song.destroy

		redirect_to songs_path
	end

	private
		def song_params
			params.require(:song).permit(:spotify_id)
		end

end