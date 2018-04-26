class ResourceController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :json
end
