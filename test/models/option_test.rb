require 'test_helper'

class OptionTest < ActiveSupport::TestCase
	test "validates option presence" do
  		option_no_option = Option.new(choice: 'A')
  		assert !option_no_option.save, 'does not validate that option text exists'
  	end
	
	test "validates choice presence" do
		option_no_choice = Option.new(option_text: 'hello world')
		assert !option_no_choice.save, 'does not validate that choice exists'
	end

	test "validates choice format" do
		option_wrong_format = Option.new(option_text: 'hello world', choice: 'asdf')
		assert !option_wrong_format.save, 'does not validate format of choice properly'
	end
end
