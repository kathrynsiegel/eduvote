class SessionsController < ApplicationController

	skip_before_filter :signed_in_user

  # GET
  # Creates a new session for a new visitor
  # However, if the user is already signed in, redirect to main user page (list of courses)
	def new
	  if signed_in?
	    redirect_to @current_user
	    return
	  end
    @user = User.new
    render 'welcome/index'
	end

  # Log user in
	def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      redirect_to user_path(@user)
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to root_url
    end
  end

  # Log user out
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
