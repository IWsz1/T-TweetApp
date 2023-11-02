require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @tweet = FactoryBot.create(:tweet)
    @user = @tweet.user
    @comment = FactoryBot.build(:comment)
    @comment.tweet_id = ""
    @comment.user_id = ""
  end

  it 'ログインしたユーザーはツイート詳細ページでコメント投稿できる' do
    # ログインする
    sign_in(@user)
    # ツイート詳細ページに遷移する
    visit tweet_path(@tweet)
    # フォームに情報を入力する
    # with:のあとは必ず半角空白
    fill_in "comment_text" ,with:@comment.text
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Comment.count }.by(1)
    # 詳細ページにリダイレクトされることを確認する
    expect(page).to have_current_path(tweet_path(@tweet))
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
    expect(page).to have_content(@comment.text)
  end
end
