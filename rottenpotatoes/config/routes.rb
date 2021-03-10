Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  # resources :movies do
  #   member do
  #     get 'search_similar_movies'
  #   end
  # end
  match 'search_directors/:id', to: 'movies#search_directors', \
    via: [:get], as: 'search_directors'
end
