class ApplicationController < ActionController::Base
  # before_actionで下層にある各コントローラーに対して事前に行うアクションであることを明記　if::コントローラー名?で設定されたコントローラーのときのみ実行することを記載
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  # deviseへ新たに追加するメソッドをconfigure_permitted_parametersというメソッドで作ることが慣習
  def configure_permitted_parameters
    # deviseの受け取れるパラメーターの宣言に新しいパラメーターを追加するメソッド
    # 第一引数にサインインサインアップアカウント情報の更新のどれかを記載　第三引数に追加したいカラム名のキーを記述する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end
