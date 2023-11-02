require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    # factoriesからデータの呼び出し
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページへ移動する
      # visitで後述ページに遷移する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      # pageで今いるページの見える箇所のみの該当データが格納されている(カーソルを合わせると見える情報等は含まれない)
      # have_contentで後述の文字列が存在するかどうかを確認する
      expect(page).to have_content("新規登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      # fill_inでフォームのラベル名(idでも良い)を指定、withにて入力したい情報を記述
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      # changeマッチャー使用時のみ()でなく{}
      expect{
        # クリック動作を行う タグ名とname必須
        find('input[name="commit"]').click
        # レコード追加に時間が掛かるケースがあるためテスト確認を1秒待機して待つ
        sleep 1
      #Userモデルに1行レコードが追加されたかを確認 
      }.to change { User.count }.by(1) 
      # リダイレクトでトップページへ遷移することを確認する
      # 今いるページのパスが後述のパス名と合致するか確認
      expect(page).to have_current_path(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        # ホバー動作を行う
        # タグ名のみでは限定できないときは親要素のクラス等を記述
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことと投稿ボタンが存在することを確認する
      # have_no_contentで存在しないかの確認を行う
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      expect(page).to have_content('投稿する')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end
RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in "Email" ,with:@user.email
      fill_in "Password" ,with:@user.password
      # ログインボタンを押す
      find("input[name='commit']").click
      # トップページへ遷移することを確認する
      expect(page).to have_current_path(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(find(".user_nav").find("span").hover)
      .to have_content("ログアウト")
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content("ログイン")
      expect(page).to have_no_content("新規登録")
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in "Email" ,with:""
      fill_in "Password" ,with:""
      # ログインボタンを押す
      find("input[name='commit']").click
      # ログインページへ戻されることを確認する
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end