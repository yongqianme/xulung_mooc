Rails.application.routes.draw do



  resources :orders

    devise_for :users

    mount RuCaptcha::Engine => "/rucaptcha"
    post 'photos' => 'photos#upload'

    get 'tech',:to=>'posts#index'
    get 'tech#show',:to=>'posts#show'
    resources :posts do
      resources :comments, :only => [:create]
      get 'posts/:id' => 'posts#show'
      post :publish
    end

    resources :pages,except: [:feed]
    resources :favorites, only: [:create, :destroy]

    get 'desktop/mycourse'
    get 'desktop/index'
    get 'desktop/tech'
    get 'desktop/report'
    get 'desktop/course'
    get 'desktop/listcourse'
    get 'desktop/listtagcourse'
    get 'desktop/sharetech'
    get 'desktop/startlearning'
    # post 'desktop/publish'

    get 'video_tags/:tag', to: 'videos#index', as: :videotag
    get 'post_tags/:tag', to: 'posts#index', as: :posttag
    get 'learning/:tag', to: 'desktop#startlearning', as: :learning


    resources :admin ,except: [:create,:new,:edit,:show,:update,:destroy] do
      member do
        post :be_provider
        post :be_admin
        post :approve_post
        post :approve_video
      end
    end

    resources :users,only: [:show,:edit]
    resources :consultants

    resources :videos do
      member do
        post :upvote
        post :publish
      end
    end
    resources :welcome,only: [:index]
    root 'welcome#home'
    get 'welcome/tos'
    get 'welocme/policy'

    # post 'setlocale/', :to=>'welcome#set'
    get 'service/telephone'
    get 'service/isthisforme'
    get 'service/successstories'
    get 'service/tech'
    get 'service/schulungapp'
    # get 'service/counselor'
    get 'service/activity'
    get 'service/membership'
    get 'service/simulation'

end
