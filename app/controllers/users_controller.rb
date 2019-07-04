class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if !@user.save
			render 'new'
		else
			redirect_to root_path
			flash[:notice] = "Account created!"
		end
	end

	def settings
		puts session[:user_id]
	end

	def user_params
		params.permit(:name, :email, :password, :password_confirmation)
	end

end
