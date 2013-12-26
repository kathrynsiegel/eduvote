require 'test_helper'

class CourseTest < ActiveSupport::TestCase
	def setup
	    @course1 = Course.create(name: 'one')
	    @course2 = Course.create(name: 'two')
	    @course3 = Course.create(name: 'onetwo')
	    @course4 = Course.create(name: 'OneTwoThree')
	    @enroll1 = Enrollment.create(phone_number: '1234567890', course_id: @course1.id)
	    @enroll2 = Enrollment.create(phone_number: '1234567890', course_id: @course1.id)
	    @enroll3 = Enrollment.create(phone_number: '2345678901', course_id: @course1.id)
	end

  	test "validates name presence" do
  		course_no_name = Course.new
  		assert !course_no_name.save, "saved Course without name"
	end

	test "validates name length" do
		course_long_name = Course.new(name: '012345678901234567890123456789')
		assert !course_long_name.save, "saved Course with name over 20 chars long"
	end

	test "validates name uniqueness" do
		course_same_name = Course.new(name:'one')
		assert !course_same_name.save, "saved Course with duplicate name"
	end

	test "correctly finds courses by starting character sequence" do
    	courses = Course.find_course_names('one')
    	assert courses.include?(@course1.name), "could not find course with same name as query"
    	assert courses.include?(@course3.name), "could not find course with name beginning with query"
    	assert courses.include?(@course4.name), "did not correctly ignore case"
    	assert courses.length == 3, "erroneously found extra courses"
	end

	test "correctly finds all unique phone numbers" do
		phone_numbers = @course1.all_unique_phone_numbers
		assert phone_numbers.include?('1234567890'), 'did not find all phone numbers for a course'
		assert phone_numbers.include?('2345678901'), 'did not find all phone numbers for a course'
		assert phone_numbers.length == 2, 'found duplicate phone numbers'
	end

	test "correctly finds all lectures with questions" do
		lecture1 = Lecture.create(name: 'a', time: Date.today + 1000, course_id: @course1.id)
		lecture2 = Lecture.create(name: 'b', time: (Date.today - 1000), course_id: @course1.id)
		lecture3 = Lecture.create(name: 'c', time: (Date.today))
		question1 = Question.create(question_text: 'asdf', lecture_id: lecture1.id, answer: 'A', course_id: @course1.id, type: 'MCQuestion')
		question2 = Question.create(question_text: 'asdfasdf', lecture_id: lecture2.id, answer: 'A', course_id: @course1.id, type: 'MCQuestion')
		lectures = @course1.lectures_with_questions
		assert lectures.include?(lecture1), 'cannot find lecture in the future'
		assert lectures.include?(lecture2), 'cannot find lecture in the past'
		assert lectures.length == 2, 'found wrong number of lectures'
		lectures2 = @course1.lectures_with_questions(true)
		assert lectures2.include?(lecture2), 'did not find lecture in the past'
		assert lectures2.length == 1, 'found wrong number of lectures in the past'
	end
end
