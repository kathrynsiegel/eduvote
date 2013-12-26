class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question_text
      t.text :choice_a
      t.text :choice_b
      t.text :choice_c
      t.text :choice_d
      t.text :choice_e
      t.timestamps
    end
  end
end
