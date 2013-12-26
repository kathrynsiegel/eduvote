class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
    	t.string :phone_number
    	t.integer :student_id
    	t.integer :course_id
      	t.timestamps
    end
  end
end
