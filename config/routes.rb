Pattana::Engine.routes.draw do

  get 'dashboard/pattana',  to: "dashboard#index",  as: :dashboard

  resources :countries,  as: :countries do
    member do
      get :regions
    end
  end

  resources :regions,  as: :regions
  resources :cities,  as: :cities

  # get '/api/v1/countries', :controller => "/api/v1/countries", action: :index, as: :api_v1_countries
  # get '/api/v1/:country_id/regions', :controller => "/api/v1/regions", action: :index, as: :api_v1_regions
  # get '/api/v1/:country_id/cities', :controller => "/api/v1/cities", action: :cities_in_a_country, as: :api_v1_cities_in_a_country
  # get '/api/v1/:country_id/:region_id/cities', :controller => "/api/v1/cities", action: :cities_in_a_region, as: :api_v1_cities_in_a_region

  # namespace :docs do
  #   namespace :api do
  #     namespace :v1 do
  #       get 'countries', to: "/api/v1/docs#countries"
  #       get 'regions', to: "/api/v1/docs#regions"
  #       get 'cities', to: "/api/v1/docs#cities"
  #     end
  #   end
  # end

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
