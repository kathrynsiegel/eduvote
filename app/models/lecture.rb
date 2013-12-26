class Lecture < ActiveRecord::Base
    
        validates :time, presence: true

        has_many :questions
        belongs_to :course

  # Simple_calendar gem needs variable start_time
        def start_time
    time
  end

  # If the lecture has no name, then display the name "Lecture x", where
  # x is the lecture number.
  def display_name
    if name
      name
    else
      lecture_number = course.lectures.order("time").index(self) + 1
      "Lecture " + lecture_number.to_s
    end
  end

  # Nicely display the date of the lecture
  def display_date
    time.strftime("%B %e, %Y")
  end

  # Get the total number of students that attended a specific lecture
  def attendance
    attendance = 0
    self.course.students.each do |student|
      if self.attended_by(student) == "yes"
        attendance += 1
      end
    end
    return attendance
  end

  # Get the total number of questions which were answered correctly
  # for a specific lecture
  def questions_correct
    correct = 0
    if self.questions.any?
      self.questions.each do |question|
        if question.responses.any?
          question.responses.each do |response|
            if response.correct?
              correct += 1
            end
          end
        end
      end
    end
    return correct
  end

  def attended_by(student)
    total_questions = self.questions.count
    answered_questions = 0
    self.questions.each do |question|
      if !question.responses.find_by(user_id: student.id).nil?
        answered_questions += 1
      end
    end

    if answered_questions == total_questions && answered_questions != 0
      "yes"
    else
      "no"
    end
  end
end
