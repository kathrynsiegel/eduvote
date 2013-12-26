class User < ActiveRecord::Base

  # Create remember token to save session
	before_create :create_remember_token
	
  # Ensure that each user has a name
  validates :name, presence: true, length: { maximum: 50 }

  # Ensure that each user has a valid, unique email
  before_save { self.email = email.downcase }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  	uniqueness: true

  # Secure passwords
  has_secure_password
  validates :password, length: { minimum: 6 }

  # Make sure every user is either an Instructor or Student
  validates :type, inclusion: { in: %w(Student Instructor) }

  # Students can belong to many courses
  has_and_belongs_to_many :courses

  # Create new remember token
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Encrypt remember token
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Check if the user is an instructor
  # Return true for instructor, false for student
  def instructor?
    type.to_s == "Instructor"
  end

  # Given a hash containing a list of existing professor emails 
  # and a string, returns a list of all the instructor emails
  # that start with that string.
  def self.find_instructor_emails(param_list)
    email_start = param_list[:email_start]
    already_added_instructors = []
    i=0
    while param_list[('instructor'+i.to_s).to_sym]
      already_added_instructors.append(param_list[('instructor'+i.to_s).to_sym])
      i+=1
    end 
    instructors = []
    Instructor.all.each do |instructor|
      if instructor.email.start_with? email_start and !already_added_instructors.include?(instructor.id.to_s)
        instructors.append(instructor)
      end
    end
    return instructors.map { |u| u.email }
  end

  # return true if there is an open question in the course
  # that the user has not submitted a response to yet
  def should_answer_question(course)
    if self.type == "Student" && !course.active_question_id.nil? 
      question = Question.find(course.active_question_id)
      return question.get_response(self).nil?
    end
    return false
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :flash => { :error => "Record not found." } 
  end

  private

    # keep remember token in order to store session
  def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
  end
end
