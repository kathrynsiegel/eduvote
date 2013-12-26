require 'test_helper'

class StudentTest < ActiveSupport::TestCase
	def setup
		@date = Date.today - 1.days
  		@course1 = Course.create(name: 'one')
		@lecture1 = Lecture.create(name: 'a', time: @date, course_id: @course1.id)
		@lecture2 = Lecture.create(name: 'b', time: @date, course_id: @course1.id)
		@question1 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdf', lecture_id: @lecture1.id, course_id: @course1.id)
		@question2 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdfjkljkl', lecture_id: @lecture1.id, course_id: @course1.id)
		@question3 = Question.create(type: 'MCQuestion', answer: 'A', question_text: 'asdfasdf', lecture_id: @lecture2.id, course_id: @course1.id)
		@student1 = Student.create(name: 'asdf', email: 'asdf@mit.edu', password: 'asdfasdf', password_confirmation: 'asdfasdf', type: 'Student', phone_number: '0987654321')
		@student2 = Student.create(name: 'asdfasdf', email: 'asdfasdf@mit.edu', password: 'asdfasdfasdf', password_confirmation: 'asdfasdfasdf', type: 'Student', phone_number:'9876543210')
		@student3 = Student.create(name: 'asdfasd', email: 'asdfasd@mit.edu', password: 'asdfasdfasd', password_confirmation: 'asdfasdfasd', type: 'Student', phone_number:'7654321098')
		@response1 = Response.create(question_id: @question1.id, value: 'A', user_id: @student1.id)
		@response2 = Response.create(question_id: @question1.id, value: 'B', user_id: @student2.id)
		@response3 = Response.create(question_id: @question2.id, value: 'A', user_id: @student1.id)
		@response4 = Response.create(question_id: @question2.id, value: 'A', user_id: @student2.id)
		@response5 = Response.create(question_id: @question3.id, value: 'A', user_id: @student1.id)
	end

	test "validates phone number presence" do
		student_no_phone = Student.create(name: 'asdfasd', email: 'asdfasd@mit.edu', password: 'asdfasdfasd', password_confirmation: 'asdfasdfasd', type: 'Student')
		assert !student_no_phone.save, 'Saves student without phone number'
	end

	test "calculates attendance properly" do
		assert @student1.attendance(@course1) == 100, 'Student attendance calculated incorrectly: ' + @student1.attendance(@course1).to_s
		assert @student2.attendance(@course1) == 50, 'Student attendance calculated incorrectly: ' + @student2.attendance(@course1).to_s
	end

	test "calculates accuracy score properly" do
		assert @student1.accuracy_score(@course1) == 100, 'Student accuracy score calculated incorrectly: ' + @student1.accuracy_score(@course1).to_s
		assert @student2.accuracy_score(@course1) == 50, 'Student accuracy score calculated incorrectly: ' + @student2.accuracy_score(@course1).to_s
	end
end
