class AddTasksCountToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :tasks_count, :integer
  end
end
