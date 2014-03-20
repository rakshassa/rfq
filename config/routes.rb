Rfq::Application.routes.draw do


  resources :rfqforms do
  	member do
  		post :build
  	end
  end

  resources :rfqquotes, :only => [:show, :edit, :update] do 
    member do
      post :submit_to_tlx
      post :send_feedback
    end
  end

  resources :parts do
  	member do
  		get :description
  	end
  end

  resources :users do
    member do
      post :tlx
      post :vendor
    end
  end

  root 'rfqforms#index'

end
