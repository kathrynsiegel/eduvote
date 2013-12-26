class DropPhoneNumberFromCourse < ActiveRecord::Migration
  def change
  	remove_column :courses, :phone_number
  end
end
