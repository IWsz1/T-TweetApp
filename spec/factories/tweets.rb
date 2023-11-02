FactoryBot.define do
  factory :tweet do
    text {Faker::Lorem.sentence}
    image {Faker::Lorem.sentence}
    # アソシエーションで繋がっている項目がバリデーションに含まれているか確認
    association :user 
  end
end