class AddLectureToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :lecture_id, :integer
  end
end
