class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:update, :destroy]

  respond_to :json

  def index
    @projects = Project.where(user_id: current_user.id).includes(:tasks)
  end

  def create
    @project = Project.new(project_params.merge(user_id: current_user.id))
    @project.save ? render(json: @project) : error_response
  end

  def update
    @project.update_attributes(project_params) ? head(200) : error_response
  end

  def destroy
    @project.destroy
    @project.destroyed? ? head(200) : error_response
  end

  private

  def project_params
    params.require(:project).permit(:id, :name)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def error_response
    render status: 400, json: { errors: @project.errors.full_messages }
  end
end
