class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    # ログインユーザーのニックネーム
    @nickname = user.nickname
    # ログインユーザーのレコードと紐づいてる複数のツイートデータ
    @tweets = user.tweets.order("created_at DESC")
  end
end
