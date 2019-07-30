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
		
	end

	def editUser
		@user = User.find(current_user.id)
	end

	def update
		@user = User.find(current_user.id)
		if !@user.authenticate(params[:password])
			flash[:error] = "Invalid password"
			redirect_to settings_editUser_path
		else
			@user.update(name: params[:name], email: params[:email], password: params[:password])

			if @user.errors.messages.empty?
				flash[:notice] = "Info updated!"
				redirect_to settings_editUser_path
			else
				render 'editUser'
			end

		end
	end	

	def updatePassword
		@user = User.find(current_user.id)
		if !@user.authenticate(params[:current_password])
			flash[:error] = "Invalid password"
			redirect_to settings_editUser_path
		else
			@user.update(password: params[:password], password_confirmation: params[:password_confirmation])

			if @user.errors.messages.empty?
				flash[:notice] = "Password updated!"
				redirect_to settings_editUser_path
			else
				render 'editUser'
			end

		end
	end


	def user_params
		params.permit(:name, :email, :password, :password_confirmation)
	end

end
