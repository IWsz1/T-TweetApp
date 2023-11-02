# テストを行う際の共通設定やメソッドを読み込む
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    it 'nicknameとemail、passwordとpassword_confirmationが存在すれば登録できる' do
    end
    it 'nicknameが空では登録できない' do
      @user.nickname = ""
      @user.valid?
      # include 期待結果が含まれているか検証
      expect(@user.errors.full_messages).to include "Nickname can't be blank"
    end
    it 'emailが空では登録できない' do
      @user.email = ""
      @user.valid?
      expect(@user.errors.full_messages).to include "Email can't be blank"
    end
    it 'passwordが空では登録できない' do
      @user.password = ""
      @user.valid?
      expect(@user.errors.full_messages).to include "Password can't be blank"
    end
    it 'passwordとpassword_confirmationが不一致では登録できない' do
      @user.password = "123456"
      @user.password_confirmation = "1234567"
      @user.valid?
      expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end
    it 'nicknameが7文字以上では登録できない' do
    @user.nickname = "1234567"
    @user.valid?
    # binding.pry
    expect(@user.errors.full_messages).to include "Nickname is too long (maximum is 6 characters)"
  end
  it '重複したemailが存在する場合は登録できない' do
    @user.save
    second_user = FactoryBot.build(:user)
    second_user.email = @user.email
    second_user.valid?
    expect(second_user.errors.full_messages).to include "Email has already been taken"
  end
  it 'emailは@を含まないと登録できない' do
    @user.email = "abcdef"
    @user.valid?
    expect(@user.errors.full_messages).to include "Email is invalid"
  end
  it 'passwordが5文字以下では登録できない' do
    @user.password = "abcde"
    @user.password_confirmation = "abcde"
    @user.valid?
    expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
  end
  it 'passwordが129文字以上では登録できない' do
    @user.password = "a" * 129
    @user.password_confirmation = @user.password
    @user.valid?
    # binding.pry
    expect(@user.errors.full_messages).to include "Password is too long (maximum is 128 characters)"
    end
  end
end
