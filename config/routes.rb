Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do

        # Clock in endpoints
        resources :sleep_logs, only: [:index, :create] do
          get :last, on: :collection
        end

      end
    end
  end
end
