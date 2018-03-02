class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  wrap_parameters :task, exclude: []
  load_and_authorize_resource
  respond_to :json

  def create
    tasks = Project.where(id: task_params[:project_id]).includes(:tasks)[0].tasks
    priority = tasks.length.zero? ? 0 : tasks.max_by(&:priority).priority + 1
    @task.priority = priority
    @task.save ? render(json: @task) : error_response
  end

  def update
    ::UpdateTask.call(@task, task_params) do
      on(:ok) { render(json: @task) }
      on(:error) { |errors| render(status: 400, json: { errors: errors }) }
    end
  end

  def destroy
    @task.destroy
    @task.destroyed? ? render(json: @task) : error_response
  end

  private

  def task_params
    params.require(:task).except(:created_at, :updated_at).permit(
      :id, :project_id, :content, :done, :deadline, :priority, :sourcepriority
    )
  end

  def error_response
    render(status: 400, json: { errors: @task.errors.full_messages })
  end
end
