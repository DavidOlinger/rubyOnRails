# config/routes.rb
Rails.application.routes.draw do
  # Define API routes under /api/v1
  namespace :api do
    namespace :v1 do
      # Route for creating a share link
      # POST /api/v1/schedules/share maps to Api::V1::SharedSchedulesController#create
      post "/schedules/share", to: "shared_schedules#create"

      # Add other API routes here if needed (e.g., for profile)
      # resources :user_profiles, only: [:index, :create] # Example
    end
  end

  # Route for viewing a shared schedule via its token
  # GET /s/some_token maps to SharedSchedulesController#show
  # The :as gives this route a name helper 'view_shared_schedule_url' used in the API controller
  get "/s/:share_token", to: "shared_schedules#show", as: "view_shared_schedule"


  # Keep existing routes (like for UserProfile if you still have it)
  resources :user_profiles, param: :username # Assuming you want to find profiles by username

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
