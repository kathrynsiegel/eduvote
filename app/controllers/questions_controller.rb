class QuestionsController < ApplicationController

	before_action :correct_instructor, only: [:new, :analysis, :destroy]

	# GET /
	# Shows all the questions for the specified course.
	# The course must belong to the current user.
	# If not, or no course specified, redirects to course index.
	def index
		@current_page = "questions/index"
		if params[:course]
			@user = current_user
			@course = Course.find(params[:course])
			if !current_user.courses.include? @course
				redirect_to user_path(current_user)
			else
				only_show_past = (current_user.type != "Instructor")
				@lectures = @course.lectures_with_questions(only_show_past).paginate(page: params[:page], per_page: 5)
			end
		else
			redirect_to user_path(current_user)
		end
	rescue ActiveRecord::RecordNotFound
  		redirect_to root_url, :flash => { :error => "Record not found." }
	end

	# GET
	# Creates a new question and creates two options by default
	def new
		@current_page = "questions/new"
		@user = current_user
		@course = Course.find(params[:course])
		@question = Question.new
		o1 = Option.create(choice: "A")
		o2 = Option.create(choice: "B")
		@options = [o1, o2]
		@lectures = @course.lectures
		@course = Course.find(params[:course])
		redirect_to(root_url) unless @course.instructors.include?(current_user)
		
		if params[:lecture]
			@selected = Lecture.find(params[:lecture])
		else
			@selected = @course.next_lecture
		end
	end

	# POST
	# Creates a new question based on the params given by the instructor.
	def create
		@user = current_user
		@question = Question.new
		@question.build_question(params)
		@selected = Lecture.find(params[:question][:lecture_id])

		# Assign a question to a course
		@course = Course.find(params[:question][:course_id])
		redirect_to(root_url) unless @course.instructors.include?(current_user)

		@lectures = @course.lectures
		@options = @question.options

		if @question.save
			# Show the course after the question is created.
			redirect_to course_path(@question.course_id)
		else
			render :new
		end
	end

	# GET
	# Displays a question.
	def show
		@current_page == "questions/index"
		@question = Question.find(params[:id])
		@user = current_user
		if !@user.courses.include?(@question.course) || (@user.type == "Student" && @question.lecture.time > Date.today)
			redirect_to(root_url)
		end
		@response = Response.new
		if @user.type == "Student"
			@saved_response = @question.get_response(@user)
			@open = @question.active?
		end
		@course = Course.find(@question.course_id)
	end

	# DELETE
	# Removes a question from the database.
	def destroy 
		course = @question.course
		@question.destroy
		course.update(active_question_id: nil)
		redirect_to course_path(course)
	end

	# Used for analyzing the response distributions by getting the relevant data
	def analysis
		@data = @question.get_responses
		@user = current_user
		@course = Course.find(@question.course_id)
	end

	# Used to analyze the response distribution by modifying the graph display
	def count_responses
		question = Question.find(params[:id])
	    render json: {count: question.count_responses}
	end

	private

	#  Used to determine whether an instructor has access to a question.
	def correct_instructor
		if params[:course] != nil
			@course = Course.find(params[:course])
			instructors = @course.instructors
		else
			@question = Question.find(params[:id])
			instructors = @question.course.instructors
		end
		redirect_to(root_url) unless instructors.include?(current_user)
	end

end
