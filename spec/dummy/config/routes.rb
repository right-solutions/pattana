Rails.application.routes.draw do
  mount Pattana::Engine => "/"
  root 'pattana/countries#index'
end
