class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :project, foreign_key: true
      t.boolean :done
      t.string :content
      t.datetime :deadline
      t.integer :priority

      t.timestamps
    end
  end
end
