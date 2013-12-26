class AddPhoneNumberToCoursesUsers < ActiveRecord::Migration
  def change
  	add_column :courses_users, :phone_number, :string
  end
end
