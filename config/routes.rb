Rails.application.routes.draw do

  #イベント用
  get 'events/index' => 'events#index'
  get 'events/show/:id' => 'events#show'
  post 'events/create' => 'events#create'
  post 'events/interest/:id' => 'events#interest'
  delete 'events/destroy/:id' => 'events#destroy' 

  #コメント用
  get 'comments/show/:id' => 'comments#show'
  post 'comments/create' => 'comments#create'
  delete 'comments/destroy/:id' => 'comments#destroy'
  
  #ユーザー用
  get 'users/index' => 'users#index'
  get 'users/like/:id' => 'users#like'
  post 'users/signin' => 'users#signin'
  post 'users/signout' => 'users#signout'
  get 'users/signedin' => 'users#signed_in'
  patch 'users/saveSettings' => 'users#save_settings'
  get 'users/show/:id' => 'users#show'
end