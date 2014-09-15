class UsersController < ApplicationController
	before_action :signed_in_user

	def index
		@users = User.paginate(page: params[:page])
	end
	def new
		@user = User.new
	end
	def show
		@user = User.find(params[:id])
		@songs = @user.songs.paginate(page: params[:page])
	end
	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "You have successfully registered for Podman."
			redirect_to @user
		else
			render 'new'
		end
	end
	def edit
	end
	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
      		redirect_to @user
		else
			render 'edit'
		end
	end	
	def destroy
    	User.find(params[:id]).destroy
    	flash[:success] = "User deleted."
    	redirect_to users_url
  	end
	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

end