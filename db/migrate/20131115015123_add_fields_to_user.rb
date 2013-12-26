class AddFieldsToUser < ActiveRecord::Migration
  	def change
  		add_column :users, :name, :string
	  	add_column :users, :email, :string
	  	add_column :users, :phone_number, :string
	  	add_column :users, :password_digest, :string
	  	add_column :users, :instructor, :boolean
  	end
end
