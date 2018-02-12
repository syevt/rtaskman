class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy]

  respond_to :json

  def create
    priority = Project.find(task_params[:project_id])
                      .tasks.max_by(&:priority).priority + 1
    @task = Task.new(task_params.merge(priority: priority))
    @task.save ? render(json: @task) : error_response
  end

  def update
    @task.update_attributes(task_params) ? head(200) : error_response
  end

  def destroy
    @task.destroy
    @task.destroyed? ? head(200) : error_response
  end

  private

  def task_params
    params.require(:task).permit(
      :id, :project_id, :content, :done, :deadline, :priority
    )
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def error_response
    render status: 400, json: { errors: @task.errors.full_messages }
  end
end
