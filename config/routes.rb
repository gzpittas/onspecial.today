# config/routes.rb
Rails.application.routes.draw do
  resources :menus do
    member do
      post :add_category
      post :add_item
      delete :clear
      get :print
    end
  end

  resources :menu_items, only: [:create, :destroy, :show] do
    member do
      patch :update_position  # For drag-and-drop reordering
    end
  end

  resources :categories
  resources :items, except: [:edit] do
    member do
      patch :update_menu_category
    end
    
    collection do
      get :search
    end
  end

  root 'menus#index'
  get "up" => "rails/health#show", as: :rails_health_check
end