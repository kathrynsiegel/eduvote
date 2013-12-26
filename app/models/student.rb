class Student < User

	# Each student must have a unique, valid phone number
  validates :phone_number, format: { with: /[0-9]{10}/ }, uniqueness: true

  # Each student is associated with many responses
  has_many :responses
  has_many :enrollments
  has_many :courses, through: :enrollments

  # Count the percentage of lectures attended by a student,
  # where a lecture is attended if all questions were answered.
  def attendance(course)
  	attended = 0
  	lectures_with_questions = 0
  	for lecture in course.lectures do
  		count = 0
        if lecture.time < Date.current
 			# Consider any lecture which has questions
  		    if lecture.questions.any?
  		        lectures_with_questions += 1
            end

  		    # Count the number questions answered in a lecture
            for question in lecture.questions do
                if question.responses.find_by(user_id: self.id)
                    count += 1
  				end

  		        # Increase attendance count if all questions were answered
                if count == lecture.questions.size
  		            attended += 1
                end
            end
  		end
  	end
    if lectures_with_questions > 0
      (attended.to_f * 100 / lectures_with_questions).to_i
    else
      100
    end
  end

  # Calculates the percentage of questions the user
  # has gotten right in a class
  def accuracy_score(course)
    correct_count = 0
    answered_count = 0
    course.questions.each do |question|
      response = question.responses.find_by_user_id(self.id)
      if response
        answered_count += 1
        if question.answer == nil or response.value.to_s.downcase == question.answer.to_s.downcase
          correct_count += 1
        end
      end
    end
    if answered_count > 0
      (correct_count * 100 / answered_count).to_i
    else
      100
    end
  end
  
end
