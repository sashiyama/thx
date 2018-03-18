FactoryBot.define do
  factory :thx_transaction do
    thx_hash { SecureRandom.hex }
    sender nil
    receiver nil
    thx { rand(1000) }
    comment { ["いつもありがとうございます", "感謝します", "これからも宜しくお願いします", "Thank you!"].sample }
  end
end
