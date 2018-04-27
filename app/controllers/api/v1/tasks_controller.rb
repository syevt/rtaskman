class Api::V1::TasksController < ResourceController
  wrap_parameters :task, exclude: []

  def create
    tasks = Project.where(id: task_params[:project_id]).includes(:tasks)[0].tasks
    priority = tasks.length.zero? ? 0 : tasks.max_by(&:priority).priority + 1
    @task.priority = priority
    respond(@task.save)
  end

  def update
    ::UpdateTask.call(@task, task_params) do
      on(:ok) { render(json: @task) }
      on(:error) { |errors| render(status: 400, json: { errors: errors }) }
    end
  end

  def destroy
    @task.destroy
    respond(@task.destroyed?)
  end

  private

  def task_params
    params.require(:task).except(:created_at, :updated_at).permit(
      :id, :project_id, :content, :done, :deadline, :priority, :sourcepriority
    )
  end
end
