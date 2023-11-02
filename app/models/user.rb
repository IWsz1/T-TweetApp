class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # メールアドレスやパスワードの基本バリデーション設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #1対複数でtweetテーブルと繋がっていることを記述  
  has_many:tweets
  has_many:comments
  # 未入力だとテーブルへ登録できない＆6文字以内出ないとテーブルへ登録できないバリデーション
  validates :nickname,presence:true, length:{maximum:6}
end
