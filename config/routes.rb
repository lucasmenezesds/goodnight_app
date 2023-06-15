Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do

        resources :relationships, only: [:index] do
          get 'following', to: 'relationships#following', on: :collection
          get 'followers', to: 'relationships#followers', on: :collection

          # Follow / Unfollow Actions
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
