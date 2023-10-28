Rails.application.routes.draw do
  # deviseGemのファイル作成を行うと自動で記述される
  devise_for :users
  # オリジナルURL（＋でパスがつかない）でもtweetsコントローラーのindexアクションが表示される
  root to:"tweets#index"
  # resourcesの書き方だとHTTPメソッドとURIは略される
  resources :tweets do
    resources :comments, only: :create
    # 7つのアクション以外ではuriにidを付与するかどうかをcollction(id非付与)かmember(id付与)で指定する
    collection do
      get 'search'
    end
  end
  resources :users, only: :show
end
