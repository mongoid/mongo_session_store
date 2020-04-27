Rails40App::Application.routes.draw do
  devise_for :users
  mount MyAppWrapped => "/rack_test"
  root :to => "home#index"
end
