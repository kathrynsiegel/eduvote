class ChangeQuestion < ActiveRecord::Migration
  	def change
	  	remove_column :questions, :choice_a
	  	remove_column :questions, :choice_b
	  	remove_column :questions, :choice_c
	  	remove_column :questions, :choice_d
	  	remove_column :questions, :choice_e
	  	add_column :questions, :answer, :string
  	end
end
