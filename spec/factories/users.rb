FactoryBot.define do
  factory :user do
    sequence(:email){|i| "example#{i}@example.com"}
    password "pass-word0000"
    password_confirmation "pass-word0000"
    address { SecureRandom.hex }
    thx_balance 1000
    status "enable"
  end

  trait :sign_in do
    after(:create) do |user|
      create(:access_token, user: user)
    end
  end
end
