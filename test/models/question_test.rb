require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
	def setup
		@question1 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdf')
		@user1 = User.create(name: 'asdf', email: 'asdf@mit.edu', password: 'asdfasdf', password_confirmation: 'asdfasdf', type: 'Student', phone_number: '0987654321')
		@user2 = User.create(name: 'asdfasdf', email: 'asdfasdf@mit.edu', password: 'asdfasdfasdf', password_confirmation: 'asdfasdfasdf', type: 'Student', phone_number:'9876543210')
		@user3 = User.create(name: 'asdfasd', email: 'asdfasd@mit.edu', password: 'asdfasdfasd', password_confirmation: 'asdfasdfasd', type: 'Student', phone_number:'7654321098')
		@response1 = Response.create(question_id: @question1.id, value: 'A', user_id: @user1.id)
		@response2 = Response.create(question_id: @question1.id, value: 'B', user_id: @user2.id)
		@response3 = Response.create(question_id: @question1.id, value: 'B', user_id: @user3.id)
	end

  	test "validates presence of mandatory question fields" do
  		question_no_text = Question.new(type: 'MCQuestion', answer: 'A')
  		assert !question_no_text.save, "saved Question without question text"
  		question_wrong_mc = Question.new(type: 'MCQuestion', answer: '123', question_text: 'asdfasdf')
  		assert !question_wrong_mc.save, "saved Question with wrongly formatted MC answer"
  		question_no_answer = Question.new(type:'MCQuestion', question_text: 'asdfasdf')
  		assert !question_no_answer.save, "saved Question without answer"
  		question_no_type = Question.new(answer: 'asdf', question_text: 'asdfasdf')
  		assert !question_no_type.save, "saved Question without question type"
  		question_wrong_non_mc = Question.new(type:'NumericQuestion', answer: '+++', question_text: 'asdfasdf')
  		assert !question_wrong_non_mc.save, "saved Question with wrong numeric format"
	end

	test "validates correct response count" do
		assert @question1.count_responses == 3, "wrong number of responses: " + @question1.count_responses.to_s
	end

	test "gets responses correctly" do
		responses = @question1.get_responses
		assert responses.length == 3, 'Found wrong number of responses: ' + responses.length.to_s
		assert responses['A'] == 1, 'Found wrong number of A responses'
		assert responses['B'] == 2, 'Found wrong number of B responses'
		assert responses['C'] == 0, 'Found wrong number of C responses'
	end

	test "gets sig fig info correctly" do
		question2 = Question.create(type: 'NumericQuestion', answer: '2.22', question_text: 'asdfasdf')
		assert question2.sig_fig_info == "Your answer should be accurate to at least 2 decimal places.", 'wrong number of sig figs determined'
	end
end
