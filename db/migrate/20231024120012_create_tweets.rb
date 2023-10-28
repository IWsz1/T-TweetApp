class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    # テーブルの型作成
    create_table :tweets do |t|
      # カラムの型　カラム名
      t.string :name
      t.string :text
      t.text :image
      # マイグレーションファイル作成時に自動作成で作成される
      # 更新日時管理
      t.timestamps
    end
  end
end
