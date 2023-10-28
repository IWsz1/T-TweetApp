class Tweet < ApplicationRecord
  # バリデーション　textが空だと保存できない設定を決定
  # 保存はされないがcreateアクションは実行されるため、送信ボタンを押すとエラー等はなくtopページに戻る
  validates :text,presence:true
  # 1:1の関係でuserテーブルと繋がっていることを記述
  # テーブルにuser_idカラムが埋められてないと保存しないという設定も含まれている
  belongs_to :user
  has_many :comments
  # 検索結果表示
  # 引数には入力された検索キーワード
  def self.search(search)
    if search != ""
      # whereで条件に一致するものを検索
      # LIKEで部分一致検索を可能にしている
      # %は何かしらの文字列_は何かしらの一文字を表す
      Tweet.where('text LIKE(?)', "%#{search}%")
    else
      Tweet.all
    end
  end
end
