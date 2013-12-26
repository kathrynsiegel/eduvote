class Enrollment < ActiveRecord::Base
	belongs_to :student
	belongs_to :course

	# Returns an unused phone number, or nil if all are in use
	def self.find_unallocated_phone_number

		# We use a predefined set of phone numbers for our purposes
		phone_numbers = ['+16173792184',
						 '+16176741419',
						 '+16175054439',
						 '+16179368164',
						 '+16179368992',
						 '+16179368805',
						 '+16173792134',
						 '+14088494309',
						 '+16174778493',
						 '+16178307637']

		# Choose an unassigned phone number
		phone_numbers.each do |number|
			unless Enrollment.find_by_phone_number(number)
				return number
			end
		end
		return nil
	end

	# Returns the course phone number in a nice display form
	# (xxx) xxx - xxxx
	def self.display_number(n)
		"(" + n[2..4] + ") " + n[5..7] + " - " + n[8..12]
	end
end
