Rfq::Application.routes.draw do


  resources :rfqforms

  resources :parts do
  	member do
  		get :description
  	end
  end

  root 'rfqforms#index'

end
