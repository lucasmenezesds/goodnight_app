Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do

        # Follow / Unfollow related endpoints
        resources :relationships, only: [:index] do
          post ':other_user_id', to: 'relationships#follow', on: :collection
          delete ':other_user_id', to: 'relationships#unfollow', on: :collection
        end

        # Clock in endpoints
        resources :sleep_logs, only: [:index, :create] do
          get :last, on: :collection
        end
      end
    end
  end
end
