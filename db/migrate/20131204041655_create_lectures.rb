class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
    	t.string :name
    	t.belongs_to :course
    	t.datetime :time

    	t.timestamps
    end
  end
end
