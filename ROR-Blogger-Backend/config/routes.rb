Rails.application.routes.draw do
  # get 'public/index'
  # get 'comment/index'
  # get 'comment/create'
  # get 'comment/update'
  # get 'comment/delete'
  # get 'blog/index'
  # get 'blog/show'
  # get 'blog/create'
  # get 'blog/update'
  # get 'blog/destroy'
  # get 'topic/index'
  # get 'topic/show'
  # get 'topic/create'
  # get 'topic/update'
  # get 'topic/destroy'
  # get 'user/index'
  # get 'user/show'
  # get 'user/create'
  # get 'user/update'
  # get 'user/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :user do
    resources :blog do
      put '/views', to: "blog#update_views"
    end
  end

  get '/blog', to: 'blog#indexall'
  post '/login', to: 'session#create'

  # Defines the root path route ("/")
  # root "articles#index"
end
