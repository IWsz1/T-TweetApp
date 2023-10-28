class AddNicknameToUsers < ActiveRecord::Migration[7.0]
  def change
    # ニックネームカラム　ターミナルからファイル自体追加
    add_column :users, :nickname, :string
  end
end
