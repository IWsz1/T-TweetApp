require 'rails_helper'

RSpec.describe 'ツイート投稿', type: :system do
  before do
    @tweet = FactoryBot.build(:tweet)
    @user = FactoryBot.create(:user)
  end
  context 'ツイート投稿ができるとき'do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content("投稿する")
      # 投稿ページに移動する
      visit new_tweet_path
      # フォームに情報を入力する
      fill_in "tweet_image" ,with:@tweet.image
      fill_in "tweet_text" ,with:@tweet.text
      # 送信するとTweetモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Tweet.count }.by(1)
      # トップページには先ほど投稿した内容のツイートが存在することを確認する（画像）
      # have_selectorで画像の確認テストができる
      expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet.image});']"
      # トップページには先ほど投稿した内容のツイートが存在することを確認する（テキスト）
      expect(page).to have_content(@tweet.text)
    end
  end
  context 'ツイート投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのボタンがないことを確認する
      expect(page).to have_no_content("投稿する")
    end
  end
end

RSpec.describe 'ツイート編集', type: :system do
  before do
    @tweet1 = FactoryBot.create(:tweet)
    @tweet2 = FactoryBot.create(:tweet)
    @user1 = @tweet1.user
    @user2 = @tweet2.user
  end
  context 'ツイート編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したツイートの編集ができる' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@user1)
      # ツイート1に「編集」へのリンクがあることを確認する
      expect(
        # allで.more(削除,編集,詳細のボタンを出す三角のアイコン)をすべて取得してその中の上から2番目(0番目を含めず)をホバー(tweet1のレコードのほうが先に保存しており新しいtweetの方が上位表示されるため)
        all('.more')[1].hover
        # have_linkはボタンの文字列と遷移するpathを設定することで確認
      ).to have_link '編集', href: edit_tweet_path(@tweet1)
      # 編集ページへ遷移する
      visit edit_tweet_path(@tweet1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('tweet_image', with: @tweet1.image)
      expect(page).to have_field('tweet_text', with: @tweet1.text)
      # 投稿内容を編集する
      # 既存内容にフォームで追記する書き方
      fill_in "tweet_image" ,with:"#{@tweet1.image} + 123"
      fill_in "tweet_text" ,with:"#{@tweet1.text} + 123"
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Tweet.count }.by(0)
      # トップページには先ほど変更した内容のツイートが存在することを確認する（画像）
      expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet1.image} + 123);']"
      # トップページには先ほど変更した内容のツイートが存在することを確認する（テキスト）
      # 追記があった際の確認方法ちょっと特殊
      expect(page).to have_content("#{@tweet1.text} + 123")
    end
  end
  context 'ツイート編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@user1)
      # ツイート2に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet2)
    end
    it 'ログインしていないとツイートの編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # ツイート1に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet2)
      # ツイート2に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet1)
    end
  end
end
RSpec.describe 'ツイート削除', type: :system do
  before do
    @tweet1 = FactoryBot.create(:tweet)
    @tweet2 = FactoryBot.create(:tweet)
  end
  context 'ツイート削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したツイートの削除ができる' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@tweet1.user)
      # ツイート1に「削除」へのリンクがあることを確認する
      expect(
        all('.more')[1].hover
      ).to have_link '削除', href: tweet_path(@tweet1)
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        all('.more')[1].hover.find_link('削除', href: tweet_path(@tweet1)).click
        sleep 1
      }.to change { Tweet.count }.by(-1)
      # トップページにはツイート1の内容が存在しないことを確認する（画像）
      expect(page).to have_no_selector ".content_post[style='background-image: url(#{@tweet1.image});']"
      # トップページにはツイート1の内容が存在しないことを確認する（テキスト）
      expect(page).to have_no_content("#{@tweet1.text}")
    end
  end
  context 'ツイート削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの削除ができない' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@tweet1.user)
      # ツイート2に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '削除', href: tweet_path(@tweet2)
    end
    it 'ログインしていないとツイートの削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # ツイート1に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '削除', href: tweet_path(@tweet1)
      # ツイート2に「削除」へのリンクがないことを確認する
      expect(
        all(".more")[0].hover
      ).to have_no_link '削除', href: tweet_path(@tweet2)
    end
  end
end
require 'rails_helper'
RSpec.describe 'ツイート詳細', type: :system do
  before do
    @tweet = FactoryBot.create(:tweet)
    @user = @tweet.user
  end
  it 'ログインしたユーザーはツイート詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
    sign_in(@user)
    # ツイートに「詳細」へのリンクがあることを確認する
    expect(
        all('.more')[0].hover
      ).to have_link '詳細', href: tweet_path(@tweet)
    # 詳細ページに遷移する
    visit tweet_path(@tweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet.image});']"
    expect(page).to have_content(@tweet.text)
    # コメント用のフォームが存在する
    # have_selectorでformの存在も確認できる
    expect(page).to have_selector"form"
  end
  it 'ログインしていない状態でツイート詳細ページに遷移できるもののコメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # ツイートに「詳細」へのリンクがあることを確認する
    expect(
      all('.more')[0].hover
      ).to have_link '詳細', href: tweet_path(@tweet)
    # 詳細ページに遷移する
    visit tweet_path(@tweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet.image});']"
    expect(page).to have_content(@tweet.text)
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector"form"
    # 「コメントの投稿には新規登録/ログインが必要です」が表示されていることを確認する
    expect(page).to have_content("コメントの投稿には新規登録/ログインが必要です")
  end
end
