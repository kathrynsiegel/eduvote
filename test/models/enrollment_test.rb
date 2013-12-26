require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
	def setup
	    @course1 = Course.create(name: 'one')
	    @enroll1 = Enrollment.create(phone_number: '+16173792184', course_id: @course1.id)
	    @enroll2 = Enrollment.create(phone_number: '+16176741419', course_id: @course1.id)
	end

  	test "can find an unallocated phone number" do
  		phone_number = Enrollment.find_unallocated_phone_number
  		assert phone_number != @enroll1.phone_number, 'not a unique phone number'
  		assert phone_number != @enroll2.phone_number, 'not a unique phone number'
	end

	test "displays number correctly" do
		assert Enrollment.display_number('+16176741419') == '(617) 674 - 1419', 'error with formatting phone number'
	end
end
