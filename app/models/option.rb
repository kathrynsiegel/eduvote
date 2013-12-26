class Option < ActiveRecord::Base

	# Each option must have text associated with it
	validates :option_text, presence: true

	# Each option corresponds to a letter choice
	validates :choice, presence: true, format: { with: /[A-Z]/ }

	# Each option belongs to a single question
	belongs_to :question
	
end
