class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #1対複数でtweetテーブルと繋がっていることを記述  
  has_many:tweets
  has_many:comments
end
