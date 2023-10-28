class TweetsController < ApplicationController
  # 優先的にメソッドの実行　exceptには実行しない　それ以外へ実行
  # ログインしてなかったら利用できないと言うメソッド
  before_action :move_to_index, except:[:index,:show,:search]

  # トップページ
  def index
    # インスタンス変数= テーブル名(大文字).all .allですべてのレコードを取得
    # @tweets = Tweet.all
    # N＋１問題の対策としてツイートテーブルと合わせてユーザーテーブルも事前に変数へ代入
    # oraderでcreted_at(作成日時)が降順の並び順で変数に代入される
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end
  # 新規投稿ページです。
  def new
    @tweet = Tweet.new
  end
  # 新規投稿のレスポンス対応でデータ追加
  def create
    # tweet_paramsで追加データをparamsの中から限定
    Tweet.create(tweet_params)
    redirect_to "/tweets"
  end
  # 削除のレスポンス対応
  def destroy
    # find（特定idのみ取得メソッド）の後に送られてきたレコードの中からidを引き出して引数として入れることで削除したいツイートのみをtweet変数に代入
    tweet = Tweet.find(params[:id])
    # テーブルを削除
    tweet.destroy
    # 処理後ootに遷移
    redirect_to root_path
  end
  # アップデート編集ページ
  def edit
    set_tweet
  end
  # アップデートのレスポンス対応データ更新
  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    redirect_to "/tweets"
  end
  # 詳細ページ
  def show
    set_tweet
    # フォーム入力欄へ渡す空レコード
    @comment = Comment.new
    # コメント一覧に渡すコメントテーブル一覧（includesでN＋①問題対応でuserテーブル読み込み）
    # includesを使用するため.all省略
    @comments = @tweet.comments.includes(:user)

  end
  def search
    # モデルのsearchメソッドで検索にかけるテーブル名.モデルで行うメソッド(モデルに引数として渡す引数)
    @tweets = Tweet.search(params[:keyword])
  end
  # プライベートの下に書いたインスタンスメソッドはクラス外で呼び出せない
  private
  def tweet_params
    # paramsハッシュは色んな情報が入っているため、取得する情報を限定するために、requireでフォーム記入欄の指定カラムと紐づけたモデル名を、permitではフォームの中の情報から更に必要な入力欄を絞るために、フォームで紐づけたカラム名を記載する
    # mergeで他データベースの値をテーブルへ追加するデータに含めることができる
    # current_userでログイン中のレコードを抽出
    params.require(:tweet).permit(:image,:text).merge(user_id: current_user.id)
  end
  def set_tweet
    @tweet = Tweet.find(params[:id])

  end
  # サインインしてなかったら指定したアクションにリダイレクト
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
