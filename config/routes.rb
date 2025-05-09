Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Theme system example
  get "theme" => "theme#index", as: :theme

  # Static pages
  get "about" => "pages#about", as: :about

  # Contact page and form submission
  get "contact" => "pages#contact", as: :contact
  post "contact" => "pages#submit_contact", as: :submit_contact

  # guide center
  get "guides" => "pages#guides", as: :guides

  # Help Center
  get "help" => "pages#help_center", as: :help_center
  get "help/:category" => "pages#help_category", as: :help_category
  get "help/:category/:article" => "pages#help_article", as: :help_article

  # Tutorials
  get "tutorials" => "pages#tutorials", as: :tutorials
  get "tutorials/:slug" => "pages#tutorial_detail", as: :tutorial_detail

  # Defines the root path route ("/")
  root "pages#index"
end
