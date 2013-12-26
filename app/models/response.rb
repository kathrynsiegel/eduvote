require 'twilio-ruby'

class Response < ActiveRecord::Base

	# Each response has a single letter value or a numeric value
	validates :value, format: { with: /\A\-?\d*\.?\d+|[A-Za-z]\z/ }

	# Each user can only have a single response per question
	validates :user, uniqueness: {scope: :question_id}

	# Each response belongs to a specific question and user
	belongs_to :question
	belongs_to :user

	# Checks whether a response is correct
	def correct?
		if self.value == self.question.answer
			true
		else
			false
		end
	end

	# Sends a message back to a user
	def process_answer(from_num, to_num, message)
		Rails.application.config.client.account.messages.create(
			:from => from_num,
			:to => to_num,
			:body => message
		)
	end

	# Rounds responses to the number of decimal places in the answer.
	def self.round_response(question, response)
		if question.type != "NumericQuestion"
			return response
		else
			resp_f = response.to_f

			# if their response was not numeric, just return their answer again
			# to_f returns 0 for non-numeric strings
			if resp_f == 0 and response.tr(".", "").squeeze != "0"
				return response
			end

			# splits answer into pre-decimal place and post-decimal place components.
			if question.answer.nil?
				dec_points = 0
			else
				ans_parts = question.answer.split(".")
				if ans_parts.length > 1
					dec_points = ans_parts[1].length
				else
					dec_points = 0
				end
			end

			# rounds to the appropriate number of decimal places
			return resp_f.round(dec_points).to_s
		end
	end

	# Processes a text received from a user and response accordingly
	def self.create_if_valid(from_number, to_number, message_body)
		# Test if the message has content and comes from some number
		if message_body and from_number
    		student = Student.find_by_phone_number(from_number[2,10])
    		# Test if the phone number from which the message is from has been registered in our system.
    		if student
    			enrollment = Enrollment.find_by(student_id: student.id, phone_number: to_number)
    			acct = Rails.application.config.client.account
    			# Test whether the user is actually enrolled in the course to which they are submitting an answer.
    			if enrollment
    				course = Course.find(enrollment.course_id)
    				# Test whether there is a question open for the course.
	    			if course.active_question_id
	    				question = Question.find(course.active_question_id)
		    			response = Response.new(value: round_response(question, message_body), user_id: student.id, question_id: question.id)
		    			# Test whether the user has already submitted a response.
		    			if response.save
		    				response.process_answer(to_number, from_number, ('We have received your answer: ' + message_body))
		    			else
		    				acct.messages.create(from: to_number, to: from_number, body: "Error: invalid response.")
		    			end
		    		else
		    			acct.messages.create(from: to_number, to: from_number, body: "No question is currently open.")
		    		end
		    	else
		    		acct.messages.create(from: to_number, to: from_number, body: "You are not enrolled in a course with this number.")
				end
    		else
    			acct.messages.create(from: to_number, to: from_number, body: "Remember to sign up for the class first!")
    		end
		end
	rescue Twilio::REST::RequestError #if a number is invalid (should never happen), handle the error from Twilio
	end

	def self.build_web_response(user, question, answer)
		response = self.round_response(question, answer)
		return question.responses.build(user_id: user.id, value: response)
	end
end
