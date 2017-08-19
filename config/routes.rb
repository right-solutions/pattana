Pattana::Engine.routes.draw do

  get 'dashboard/pattana',  to: "dashboard#index",  as: :dashboard

  resources :countries,  as: :countries do
    member do
      get :regions
    end
  end

  resources :regions,  as: :regions
  resources :cities,  as: :cities

end
