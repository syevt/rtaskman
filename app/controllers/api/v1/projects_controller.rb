class Api::V1::ProjectsController < ResourceController
  def index
    @projects = @projects.order(id: :asc).includes(:tasks)
  end

  def create
    @project.user = current_user
    respond(@project.save)
  end

  def update
    respond(@project.update_attributes(project_params))
  end

  def destroy
    @project.destroy
    respond(@project.destroyed?)
  end

  private

  def project_params
    params.require(:project).permit(:id, :name)
  end
end
