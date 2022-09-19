Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "articles/:id", to: "articles#show"
  get "articles", to: "articles#index"
  delete "articles/:id", to: "articles#destroy"
  post "articles/:id", to: "articles#like"
end
