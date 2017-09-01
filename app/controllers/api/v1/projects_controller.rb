class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def index
    @projects = Project.where(user_id: params[:user_id])
  end
end
