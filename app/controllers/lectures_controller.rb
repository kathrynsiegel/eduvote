class LecturesController < ApplicationController

	before_action :instructor, only: [:rename, :destroy, :create]
	before_action :set_lecture_and_verify, only: [:show, :destroy]

	# GET
	# show all the lectures for a course
	def show
		@user = current_user
		@course = @lecture.course
	end

	# POST
	# create a new lecture
	def create
		time = DateTime.parse(params[:lecture][:date])
		course = Course.find(params[:lecture][:course])
		q = ['time >= ? AND time < ? AND course_id = ?', time, time + 1.days, params[:lecture][:course]]
		lecture = Lecture.where(q).first
		if lecture.nil? && current_user.courses.include?(course)
			new_lecture = course.lectures.create(time: time)
		end
		redirect_to course_path(course)
	end

	# GET
	# Rename a given lecture
	def rename
		time = DateTime.parse(params[:date])
		course = params[:course]
		q = ['time >= ? AND time < ? AND course_id = ?', time, time + 1.days, course]
		lecture = Lecture.where(q).first
		if lecture && current_user.courses.include?(lecture.course)
			lecture.name = params[:name]
			if lecture.save
				render json: {name: lecture.name}
			end
		else
			render nothing:true
		end
	end

	# DESTROY
	# Delete a lecture
	def destroy
		@course = @lecture.course 
		@lecture.destroy
		redirect_to course_path(@course)
	end

	private

		def set_lecture_and_verify
			@lecture = Lecture.find(params[:id])
			if !current_user.courses.include?(@lecture.course) || (current_user.type == "Student" && @lecture.time >= Date.today)
				redirect_to(user_path(current_user))
			end
		rescue ActiveRecord::RecordNotFound
  			redirect_to root_url, :flash => { :error => "Record not found." }
		end

end
