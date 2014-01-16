Munidontleaveme::Application.routes.draw do
   root :to => 'home#index'

   resources :muni

   get 'route' => 'home#show' 
   get 'stop_detail'  => 'home#stop_detail' 
end
