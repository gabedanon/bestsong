class VotesController < ApplicationController
	def new
		if params[:winner] == '0'
			winner = params[:song1]
			loser = params[:song2]
		elsif params[:winner] == '1'
			winner = params[:song2]
			loser = params[:song1]
		else
		end			
		vote = Vote.new(for_id: winner, against_id: loser)
		vote.save
		redirect_to results_path(params)
	end
end