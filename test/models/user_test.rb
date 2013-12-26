require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@question1 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdf')
		@user1 = User.create(name: 'asdf', email: 'asdf@mit.edu', password: 'asdfasdf', password_confirmation: 'asdfasdf', type: 'Instructor')
		@user2 = User.create(name: 'asdfasdf', email: 'asdfasdf@mit.edu', password: 'asdfasdfasdf', password_confirmation: 'asdfasdfasdf', type: 'Instructor')
		@user3 = User.create(name: 'asdfasd', email: 'asdasd@mit.edu', password: 'asdfasdfasd', password_confirmation: 'asdfasdfasd', type: 'Instructor')
		@user4 = User.create(name: 'qwerqwer', email: 'asdasdqwer@mit.edu', password: 'asdfasqwer', password_confirmation: 'asdfasdfasd', type: 'Student', phone_number: '1234059387')
		@response1 = Response.create(question_id: @question1.id, value: 'A', user_id: @user1.id)
		@response2 = Response.create(question_id: @question1.id, value: 'B', user_id: @user2.id)
		@response3 = Response.create(question_id: @question1.id, value: 'B', user_id: @user3.id)
	end

	test "validates the presence and format of essential fields" do
		user_temp = User.new(email: 'qwer@mit.edu', password: 'qwerqwer', password_confirmation: 'qwerqwer', type: 'Student', phone_number: '3358423473')
		assert !user_temp.save, 'Does not validate presence of name'
		user_temp = User.new(name: 'qwer', password: 'qwerqwer', password_confirmation: 'qwerqwer', type: 'Student', phone_number: '3358423473')
		assert !user_temp.save, 'Does not validate presence of email'
		user_temp = User.new(name: 'qwer', email: 'qwer', password: 'qwerqwer', password_confirmation: 'qwerqwer', type: 'Student', phone_number: '3358423473')
		assert !user_temp.save, 'Does not validate format of email'
		user_temp = User.new(name: 'qwer', email: 'qwer@mit.edu', type: 'Student', phone_number: '3358423473')
		assert !user_temp.save, 'Does not validate presence of password'
		user_temp = User.new(name: 'qwer', email: 'qwer@mit.edu', password: 'qwerqwer', password_confirmation: 'qwerqwer', phone_number: '3358423473')
		assert !user_temp.save, 'Does not validate presence of type'
	end

	test "validates instructor test" do
		assert @user1.instructor?, 'Instructor test is wrong when testing an instructor'
		assert !@user4.instructor?, 'Instructor test is wrong when testing a student'
	end

	test "correctly finds instructor emails" do
		list = User.find_instructor_emails({email_start: 'asdf'})
		assert list.length == 2, 'Does not find the correct number of instructors'
		assert list.include?(@user1.email), 'Does not find appropriate instructors'
		assert list.include?(@user2.email), 'Does not find appropriate instructors'

		list2 = User.find_instructor_emails({email_start: 'asdf', instructor0: @user1.id.to_s})
		assert list.include?(@user2.email), 'Does not find appropriate filtered instructors'
	end
end
