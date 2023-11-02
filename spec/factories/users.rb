FactoryBot.define do
  factory :user do
    # nickname              {'test'}
    # email                 {'test@example'}
    # password              {'000000'}
    # password_confirmation {password}
    nickname              {Faker::Name.initials(number: 2)}
    email                 {Faker::Internet.email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
  end
end