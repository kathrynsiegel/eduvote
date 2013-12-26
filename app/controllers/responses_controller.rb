class ResponsesController < ApplicationController
	skip_before_filter :signed_in_user, only: :new

	# GET
	# Respond to texts sent to the provided Twilio number
	def new
		message_body = params["Body"].upcase.squish
    	from_number = params["From"]
    	to_number = params["To"]

    	Response.create_if_valid(from_number, to_number, message_body)

		redirect_to "/"
	end

	def create
		@question = Question.find(params[:response][:question])
		@user = current_user
		unless (@user.courses.include?(@question.course) && @question.active?)
			redirect_to(root_url)
		else
			@response = Response.build_web_response(@user, @question, params[:response][:value])
			if @response.save
				@saved_response = @response
				@open = false
			else
				@open = @question.active?
			end
			@course = Course.find(@question.course_id)
			render 'questions/show'
		end
	end   
end