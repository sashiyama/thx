FactoryBot.define do
  factory :user do
    email "MyString"
    password_digest "MyString"
    address { SecureRandom.hex }
    thx_balance 1000
    status "enable"
  end
end
