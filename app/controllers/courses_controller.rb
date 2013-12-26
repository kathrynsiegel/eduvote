class CoursesController < ApplicationController

	before_action :instructor, except: [:find, :show, :search]
	before_action :verify_and_set_course, only: [:show, :update, :destroy, :students]

	# GET
	# Creates a new course
	def new
		@course = Course.new

		# By default, only the creater is an instructor
		@instructors = [current_user]
	end

	# POST
	# Creates a new course given information provided by the instructor.
	def create
		@course = Course.new
		@course.build_course(params)
		@instructors = @course.instructors
		@user = current_user

		start_date, end_date, date_errors = @course.get_dates(params)

		if @course.valid? && !date_errors.any?
				@new_course_error = false
				@course.save
				@course.generate_lectures(params, start_date, end_date)
				redirect_to course_path(@course) # Instructor's main page
		else
			@new_course_error = true
			@course.update_errors(date_errors)
			render 'users/show'
		end
	end

	# GET
	# Show everything associated with a course.
	def show
		@current_page = "courses/show"
		@user = current_user
		unless @user.instructor? 
			@attendance = @user.attendance(@course).to_i 
			@accuracy_score = @user.accuracy_score(@course).to_i
		end

		#calendar
		@events = Lecture.all.where(course_id: params[:id])
		if DateTime.now < @course.start_datetime
			@start_month = @course.start_datetime.month
			@start_year = @course.start_datetime.year
		elsif DateTime.now > @course.end_datetime
			@start_month = @course.end_datetime.month
			@start_year = @course.end_datetime.year
		else
			@start_month = DateTime.now.month	
			@start_year = DateTime.now.year
		end
	end

	# PUT
	# Update the course information with the information provided by the instructor
	def update
		open_close = params[:open_close]
		if open_close #only used when opening and closing a question
			if open_close == 'open'
				# only one question can be open at a time for a course
				@course.update(active_question_id: params[:question_id])
			elsif open_close == 'close'
				# possible for no questions to be open
				@course.update(active_question_id: nil)
			end
			redirect_to question_url(params[:question_id])
		else
			redirect_to course_url(@course)
		end
	end

	# DELETE
	# Deletes a course from the database.
	def destroy
		@course.destroy
		redirect_to user_path(current_user)
	end

	# Uses ajax to look up a Course by name, and then adds the student to the Course
	def find
		user = current_user
	    if !params[:name] # no student
	      	render nothing:true
	    else
		    course = Course.find_by(name: params[:name])
		    if !course || user.courses.include?(course) # no course
		      	render nothing:true
		    else
		    	phone_number = '0000000000'
		      	if course.students.length % 50 == 0 # handles multiple phone numbers per course, only allows 50 students per course per phone number
		      		phone_number = Enrollment.find_unallocated_phone_number
					unless phone_number # For monetary reasons, we only support up to 10 courses. This can easily be expanded. Twilio also allows for allocation of new phone numbers via the app, but this would be very expensive.
						flash[:alert] = 'Maximum number of courses and students reached. Please contact eduvote@mit.edu to increase this number.'
						redirect_to user_path(user)
						return
					end
				else #find the last enrollment added and use that phone number
					phone_number = course.enrollments.last.phone_number
		      	end
		      	enrollment = Enrollment.create(student: user, course: course, phone_number: phone_number)
		      	# welcomes user to the class when they register online
		      	Rails.application.config.client.account.messages.create(from: phone_number, to: user.phone_number, body: ("Welcome to " + course.name))
		        render json: {name: course.name, id: course.id, number: Enrollment.display_number(phone_number), instructors: course.instructors, attendance: current_user.attendance(course), accuracy: current_user.accuracy_score(course)}
		    end
	    end
  	end

  	# Use AJAX to find course names that start with the given string.
    # Used for autocomplete when students add courses.
    def search
      if !current_user || !params[:name_start]
        render nothing:true
      else
        courses = Course.find_course_names(params[:name_start])
        render text: courses
      end
    end

    # GET
    # Show the gradebook module for students for a course
    def students
    	@current_page = "courses/students"
    	@user = current_user
    end

	private

		# Only let through acceptable parameters
    	def course_params
      		params.require(:course).permit(:name, :users)
    	end

    	def verify_and_set_course
    		@course = Course.find(params[:id])
    		redirect_to(user_path(current_user)) unless current_user.courses.include?(@course)
       	rescue ActiveRecord::RecordNotFound
  			redirect_to root_url, :flash => { :error => "Record not found." }
       	end

end
