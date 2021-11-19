Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  namespace :admin do
    resources :spots, :except => :show
  end

  get "spot/choice1" => "spots#choice1", as: "choice1_spot"
  post "spot/choice2" => "spots#choice2", as: "choice2_spot"
  get "spot/root"   => "spots#root",   as: "spot_root"
  resources :spots, :only => [:index, :show]

end
