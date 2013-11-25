Rails.application.routes.draw do
  resources :dummies
  namespace 'admin' do
    resources :dummies
  end
end
