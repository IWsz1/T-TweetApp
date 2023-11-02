class Comment < ApplicationRecord
  # アソシエーション設定
  belongs_to :user
  belongs_to :tweet

  validates :text,presence:true
end
