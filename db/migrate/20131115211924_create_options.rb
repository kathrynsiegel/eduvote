class CreateOptions < ActiveRecord::Migration
  	def change
	    create_table :options do |t|
	      	t.belongs_to :question
	      	t.text :option_text
	      	t.string :choice
	      	t.timestamps
	    end
  	end
end
