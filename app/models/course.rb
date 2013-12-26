class Course < ActiveRecord::Base

	# courses must have a unique name so students can look them up to register
	validates :name, presence: true, uniqueness: true, length: { maximum: 20 }

	# each course has many instructors and many students
	has_and_belongs_to_many :users
 	has_and_belongs_to_many :instructors, association_foreign_key: 'user_id', join_table: 'courses_users'
 	has_many :enrollments
 	has_many :students, through: :enrollments

 	# each course has many questions
	has_many :questions, :dependent => :destroy

	# each course has many lectures
	has_many :lectures, :dependent => :destroy

	# Given a string, returns a list of all the course names
    # that start with that string.
    def self.find_course_names(name_start)
        courses = Course.all.order("name").select { |c| c.name.downcase.start_with? name_start.downcase } 
        return courses.map { |c| c.name }
    end

    def all_unique_phone_numbers
        phone_numbers = self.enrollments.map { |enrollment| enrollment.phone_number }
        phone_numbers.uniq{|phone_number| phone_number}
    end

    def lectures_with_questions(only_past=false)
        results = []
        if only_past
            lectures_to_filter = self.lectures.where("time < ?", Date.today).order("time DESC")
        else
            lectures_to_filter = self.lectures.order("time DESC")
        end
        lectures_to_filter.each do |l|
            if l.questions.size > 0
                results << l
            end
        end
        return results
    end

    # Create a course from params (does not generate lectures)
    def build_course(params)
        instructors = []
        self.name = params[:course][:name]

        # add all of the instructors to the course
        for i in params[:course][:instructors]
            if i.length > 0 then instructors.push(Instructor.find(i)) end
        end
        self.instructors = instructors
    end

    # Get the start and end dates corresponding to the course
    # Return the start_date, the end_date, and any errors.
    def get_dates(params)
        errors = []

        # Read the start date parameters. If valid, create a new date
        start_year = params['start']['year'].to_i
        start_month = params['start']['month'].to_i
        start_day = params['start']['day'].to_i
        if Date.valid_date?(start_year, start_month, start_day)
            start_date = DateTime.new(start_year, start_month, start_day)
        else
            errors.push("Invalid start date")
        end

        # Read the end date parameters. If valid, create a new date
        end_year = params['end']['year'].to_i
        end_month = params['end']['month'].to_i
        end_day = params['end']['day'].to_i
        if Date.valid_date?(end_year, end_month, end_day)
            end_date = DateTime.new(end_year, end_month, end_day)
        else
            errors.push("Invalid end date")
        end

        # If start and end dates were valid, make sure start date comes first
        if !errors.any?
            if start_date > end_date
                errors.push("Start date cannot be before end date")
            end
        end

        return start_date, end_date, errors
    end

    # Add the errors corresponding to the dates to the list of
    # errors for the course
    def update_errors(date_errors)
        for error in date_errors
            self.errors[:base] = error
        end
    end

    # Generate all the lectures corresponding to the course.
    # For any day of the week marked as a 'lecture day', create
    # lecture between start_date and end_date (assumed to be valid).
    def generate_lectures(params, start_date, end_date)
        # Get the numeric values for the lecture days
        days = []
        for i in (1..5)
            if params[i.to_s]
                days.push(i)
            end
        end

        # Generate all the lectures
        for d in (start_date..end_date)
            # If a lecture should occur on that day
            if days.include?(d.wday)
                l = Lecture.create(course_id: self.id, time: d)
            end
        end
    end

    # Display a course number for a particular student in the form (xxx)- xxx - xxxx
    def display_number(student)
        enrollment = student.enrollments.find_by(course_id: self.id)
        number = enrollment.phone_number
        Enrollment.display_number(number)
    end

    # Get the next lecture in time
    def next_lecture
        return self.lectures.where("time >= ?", Date.today).order("time").first
    end

    # Get the time corresponding to the first lecture in the class
    def start_datetime
        if self.lectures.any?
            self.lectures.order(:time).first.time
        else
            DateTime.now
        end
    end

    # Get the time corresponding to the last lecture in the class
    def end_datetime
        if self.lectures.any?
            self.lectures.order(:time).last.time
        else
            DateTime.now
        end
    end
end
