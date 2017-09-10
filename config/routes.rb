Pattana::Engine.routes.draw do

  get 'dashboard/pattana',  to: "dashboard#index",  as: :dashboard

  scope :admin do
    resources :countries,  as: :countries do
      member do
        get :regions
      end
    end

    resources :regions,  as: :regions
    resources :cities,  as: :cities
  end

  namespace :api do
    namespace :v1 do
      get 'countries', :controller => "countries", action: :index
      get ':country_id/regions', :controller => "regions", action: :index
      get ':country_id/cities', :controller => "cities", action: :cities_in_a_country
      get ':country_id/:region_id/cities', :controller => "cities", action: :cities_in_a_region
    end
  end
  
  scope :docs do
    namespace :api do
      namespace :v1 do
        get 'countries', :controller => "docs"
        get 'regions', :controller => "docs"
        get 'cities_in_a_country', :controller => "docs"
        get 'cities_in_a_region', :controller => "docs"
      end
    end
  end

end
