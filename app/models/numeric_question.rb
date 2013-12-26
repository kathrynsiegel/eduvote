class NumericQuestion < Question
	# Each question must have text (the actual question)
	validates :question_text, presence: true

	# Each question must have a type (NumericQuestion or MCQuestion)
	validates :type, presence: true
	validates :answer, format: { with: /\A\-?\d*\.?\d+\z/ }

end