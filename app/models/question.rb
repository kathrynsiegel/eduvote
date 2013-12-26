class Question < ActiveRecord::Base

	# Each question must have text (the actual question)
	validates :question_text, presence: true

	# Each question must have a type (NumericQuestion or MCQuestion)
	validates :type, presence: true
	validates :answer, format: { with: /[A-Z]/ }, if: "type==MCQuestion"
	validates :answer, format: { with: /\A\-?\d*\.?\d+\z/ }, if: "type==NumericQuestion"

	# Each question belongs to a course
	belongs_to :course

	# Each question belongs to a lecture
	belongs_to :lecture

	# Each question has many options and many responses
	has_many :responses, :dependent => :destroy
	has_many :options, :dependent => :destroy

	# Get the number of responses for a question so far
	def count_responses
		self.responses.length
	end

	# Get the number of people which answered each option
	def get_responses
		responses_hash = Hash.new(0)
		self.responses.each do |resp|
			responses_hash[resp.value.upcase] += 1 
		end
		if self.type == "MCQuestion"
			invalid = self.responses.length
			self.options.each do |opt|
				invalid -= responses_hash[opt.choice.upcase]
			end
			responses_hash[:invalid] = invalid
		else
			sorted_list = responses_hash.sort_by { |key, value| -value }
			responses_hash = sorted_list.slice(0, 10).sort_by { |key, value| key.to_f }
		end
		return responses_hash
	end

	# Build a question from parameters
	def build_question(params)
		self.type = params[:question][:type]
		self.question_text = params[:question][:question_text]
		self.course_id = params[:question][:course_id]
		self.lecture_id = params[:question][:lecture_id]
		answer_key = self.type == "MCQuestion" ? :mc_answer : :num_answer
		self.answer = (params[:question][answer_key] == "") ? nil : params[:question][answer_key]

		if self.type == "MCQuestion"
			for o in params[:question][:options]
				option = Option.new
				option.choice = o[:choice]
				option.option_text = o[:option_text]
				self.options.push(option)
			end
		end
	end

	# Get a string describing the number of sig figs, if applicable.
	def sig_fig_info
		if self.type == "NumericQuestion" && self.answer != nil
			pieces = self.answer.split(".")
			places = pieces.length > 1 ? pieces[1].length.to_s : "0"
			if places == "0"
				return "Your answer should be an integer."
			else
				"Your answer should be accurate to at least " + places + " decimal places."
			end
		end
	end

	def active?
		return self.course.active_question_id == self.id
	end

	def get_response(user)
		return self.responses.find_by(user_id: user.id)
	end

end
