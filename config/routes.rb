Rails.application.routes.draw do

  devise_for :admins

  namespace :admin do
    resources :spots, :except => :show
    get "spot/search"   => "spots#search",   as: "spot_search"
  end

  get  "spot/choice1" => "spots#choice1", as: "choice1_spot"
  post "spot/choice2" => "spots#choice2", as: "choice2_spot"
  get  "spot/similar" => "spots#similar", as: "similar_spot"
  get  "spot/root"    => "spots#root",   as: "spot_root"
  resources :spots, :only => [:index, :show]

  root to: 'homes#top'

end
