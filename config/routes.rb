KathrynsiegelCmobrienQuiAnnietang92Final::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root "welcome#index"

  post "signin/", to: "sessions#create"
  get "signout/", to: "sessions#destroy"
  get '/about', to: "welcome#about"
  get '/test', to: "welcome#test"
  get "courses/:id/students" => "courses#students"

  resources :users, only: [:show, :create, :edit, :destroy] do
    collection do
      post "find_instructor"
      get "search_instructors"
      post "unregister"
    end
  end

  resources :courses do
    collection do
      post "find"
      get "search"
    end
  end

  resources :lectures, only: [:show, :destroy, :create] do
    collection do
      post "rename"
    end
  end
  
  resources :responses, only: [:new, :create]

  resources :questions, only: [:index, :new, :create, :show, :destroy] do
    member do
      get 'analysis'
      get 'count_responses'
    end
  end

  get "*path", to: redirect("/")
end
