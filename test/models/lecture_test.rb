require 'test_helper'

class LectureTest < ActiveSupport::TestCase
  	def setup
  		@date = Date.today
  		@course1 = Course.create(name: 'one')
		@lecture1 = Lecture.create(name: 'a', time: @date, course_id: @course1.id)
	end

  	test "validates time presence" do
  		lecture_no_time = Lecture.new
  		assert !lecture_no_time.save, "saved Lecture without time"
	end

	test "correctly gets start time" do
		assert @lecture1.start_time == @date, 'incorrectly accesses date'
	end

	test "correctly displays name" do
		lecture_no_name = Lecture.create(time: @date, course_id: @course1.id)
		assert @lecture1.display_name == 'a', 'incorrectly displays name of lectures with assigned name'
		assert lecture_no_name.display_name == 'Lecture 2', 'incorrectly displays name of lectures with no name assigned'
	end
end
