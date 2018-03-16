FactoryBot.define do
  factory :thx_transaction do
    thx_hash "MyString"
    sender nil
    receiver nil
    thx 1
    comment "MyText"
  end
end
