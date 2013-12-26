class UsersController < ApplicationController

	before_action :signed_in_user, only: [:show, :index]
	before_action :correct_user, only: [:show]

  # GET
  # Display a user
	def show
    @current_page = "users/show"
    @user = User.find(params[:id])
    if @user.courses.any?
      @new_course_error = false;
    else
      @new_course_error = true;
    end
    @course = Course.new
    # The head instructor for the course (the course creator)
    @instructors = [current_user]
  end

  # POST
  # Creates a new user based on the parameters submitted by the user
	def create
    @user = User.new(user_params)
    if @user.type == "Instructor"
      @user.phone_number = ""
    end
    if @user.save
      RegistrationMailer.welcome_email(@user).deliver
      @sign_up_error = false
      sign_in @user
      redirect_to user_path(@user)
    else
      @sign_up_error = true
      render 'welcome/index'
    end
  end

  # Used to modify user registration
  def edit
    @user = User.find(params[:id])
    @users = User.where.not(id: @user.id)
  end

  # Use Ajax to find the instructor of a class. Used when adding other instructors to a class.
  def find_instructor
    if !current_user || !params[:email]
      render nothing:true
    else
      user = User.find_by(email: params[:email])
      if !user || !user.instructor?
        render nothing:true
      else
        render json: {name: user.name, email: user.email, id: user.id}
      end
    end
  end

  # Use AJAX to find instructor emails that start with the given string.
  # Used for autocomplete when adding instructors.
  def search_instructors
    if !current_user || !params[:email_start]
      render nothing:true
    else
      instructors = User.find_instructor_emails(params)
      render text: instructors
    end
  end

  # Used to unregister for a class.
  def unregister
    if current_user.class == Student
      course = Course.find(params[:course])
      current_user.courses.destroy(course)
    end
    redirect_to root_url
  end

  private

    # Only let certain parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :phone_number, :type,
                                   :password, :password_confirmation)
    end

    # Only let the user view his/her own page
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Record not found." }
    end
end
