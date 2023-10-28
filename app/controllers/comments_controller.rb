class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)
    # tweetのshowへ遷移
    # redirect_to "/tweets/#{comment.tweet.id}"
    redirect_to "/tweets/#{comment.tweet.id}" 
  end
  private
  def comment_params
    # permitはフォームで入力された情報のみのためtextのみです。
    # paramsのtweet_idには送付元詳細ページのuriパターンの中のtweet_idに当てはまる数字が入っている（ツイートテーブルのidがそこには入る設定）
    params.require(:comment).permit(:text).merge(user_id: current_user.id,tweet_id:params[:tweet_id])
  end
end
