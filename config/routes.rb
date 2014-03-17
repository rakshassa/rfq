Rfq::Application.routes.draw do


  resources :rfqforms do
  	member do
  		post :build
  	end
  end

  resources :parts do
  	member do
  		get :description
  	end
  end

  root 'rfqforms#index'

end
