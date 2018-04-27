class ResourceController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :json

  private

  def respond(success)
    resource = instance_variable_get("@#{controller_name.singularize}")
    return render(json: resource) if success
    render(status: 400, json: { errors: resource.errors.full_messages })
  end
end
