module TweetsHelper
  def tweet_lists(tweets)
    # 変数を宣言
    html = ''
    tweets.each do |tweet|
      # renderを使うとすべてのデータを表示させられる
      html += render(partial: 'tweet',locals: { tweet: tweet })
    end
    # 文字化け対策＆html変数を返す
    return raw(html)
  end
end
