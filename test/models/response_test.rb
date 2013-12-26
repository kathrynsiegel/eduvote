require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
	def setup
	    @question1 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdf')
		@user1 = User.create(name: 'asdffff', email: 'asdffff@mit.edu', password: 'asdfasdf', password_confirmation: 'asdfasdf', type: 'Student', phone_number: '0987654322')
		@user2 = User.create(name: 'asdfasdff', email: 'asdfasdff@mit.edu', password: 'asdfasdfasdf', password_confirmation: 'asdfasdfasdf', type: 'Student', phone_number:'9876543212')
		@user3 = User.create(name: 'asdfasdf', email: 'asdfasdfff@mit.edu', password: 'asdfasdfasd', password_confirmation: 'asdfasdfasd', type: 'Student', phone_number:'7654321092')
		@response1 = Response.create(question_id: @question1.id, value: 'A', user_id: @user1.id)
		@response2 = Response.create(question_id: @question1.id, value: 'B', user_id: @user2.id)
		@response3 = Response.create(question_id: @question1.id, value: 'B', user_id: @user3.id)
	end

  	test "validates manditory fields' presence" do
  		response_no_value = Response.new(user_id: @user1.id)
  		assert !response_no_value.save, "saved Response without value"
	end

	test "correctly tests correctness" do
		assert @response1.correct?, 'deems correct answer incorrect'
		assert !@response2.correct?, 'deems incorrect answer correct'
	end

	test "processes answers" do
		# Must be tested manually by testing whether a user receives a text message
		# from our app.
	end

	test 'correctly rounds responses' do
		question2 = Question.create(type: 'NumericQuestion', answer: '2.2', question_text: 'asdfasdfasdf')
		response21 = Response.create(question_id: question2.id, value: '2.23', user_id: @user1.id)
		assert Response.round_response(question2, '2.23') == '2.2', 'Rounds responses incorrectly'
	end
end
