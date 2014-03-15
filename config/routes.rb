Rfq::Application.routes.draw do


  resources :rfqforms

  root 'rfqforms#index'

end
