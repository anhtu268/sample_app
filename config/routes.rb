Rails.application.routes.draw do
  root "static_pages#home"

  resources :static_pages do
    get "home", on: :collection
    get "help", on: :collection
    get "about", on: :collection
    get "contact", on: :collection
  end
end
