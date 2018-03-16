FactoryBot.define do
  factory :access_token do
    user nil
    token { SecureRandom.hex }
    refresh_token { SecureRandom.hex }
    issued_at { Time.zone.now }
    refresh_token_issued_at { Time.zone.now }
  end
end
