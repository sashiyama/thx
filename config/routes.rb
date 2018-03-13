Rails.application.routes.draw do
  mount Endpoint::API => '/'
end
