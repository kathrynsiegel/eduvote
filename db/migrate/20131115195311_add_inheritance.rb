class AddInheritance < ActiveRecord::Migration
  	def change
	  	add_column :users, :type, :string
	  	remove_column :users, :instructor
  	end
end
