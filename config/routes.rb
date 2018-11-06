Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root to: 'home#index'

  get 'home/index'

  namespace :api do
    namespace :v1 do
      resources :projects, except: [:new, :show, :edit],
                           defaults: { format: :json }
      resources :tasks, only: [:create, :update, :destroy]
    end
  end
end
