Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root to: 'home#index'

  get 'home/index'

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resources :projects, only: [:index, :create, :update, :destroy],
                             defaults: { format: :json }
      end
    end
  end
end
