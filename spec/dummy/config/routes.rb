Rails.application.routes.draw do
  mount Pattana::Engine => "/"
  # root to: "demo/home#index"
end
