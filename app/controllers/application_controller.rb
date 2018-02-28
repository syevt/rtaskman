class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do
    render(status: 403, json: { errors: [t('cancancan.unauthorized')] })
  end
end
