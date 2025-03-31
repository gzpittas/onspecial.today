# config/routes.rb
Rails.application.routes.draw do
  resources :menus do
    member do
      post :add_category
      post :add_item
    end
  end
  
  resources :categories
  resources :items, except: [:edit] do
    member do
      patch :update_menu_category  # Add this line inside the items block
    end
    
    collection do
      get :search
    end
  end
  
  root 'menus#index'

  get "up" => "rails/health#show", as: :rails_health_check
end