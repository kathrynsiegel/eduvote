class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      	t.string :name
      	t.string :phone_number
      	t.integer :active_question_id
      	t.timestamps
    end
  end
end
