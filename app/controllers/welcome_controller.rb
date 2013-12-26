class WelcomeController < ApplicationController
	skip_before_filter :signed_in_user

	# GET
	# Used on main page to create new user.
	def index
		if current_user
			redirect_to user_url(current_user)
		else
			@user = User.new
		end
	end

	# Refers to about page.
	def about
		@user = User.new
	end

end
