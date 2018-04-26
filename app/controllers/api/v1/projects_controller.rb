class Api::V1::ProjectsController < ResourceController
  def index
    @projects = @projects.order(id: :asc).includes(:tasks)
  end

  def create
    @project.user = current_user
    @project.save ? render(json: @project) : error_response
  end

  def update
    if @project.update_attributes(project_params)
      render(json: @project)
    else
      error_response
    end
  end

  def destroy
    @project.destroy
    @project.destroyed? ? render(json: @project) : error_response
  end

  private

  def project_params
    params.require(:project).permit(:id, :name)
  end

  def error_response
    render(status: 400, json: { errors: @project.errors.full_messages })
  end
end
