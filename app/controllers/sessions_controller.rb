class SessionsController < ApplicationController

	def new
		user = User.where(email: params[:email].downcase).first
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:notice] = "Logged In"
		else
			flash[:error] = "Invalid User/Pass"
		end
		redirect_to root_path
	end

	def destroy
		session.delete(:user_id)
		@current_user = nil
		flash[:notice] = "Logged Out"
		redirect_to root_path
	end


	def user_params
		params.permit(:email, :password)
	end

end
