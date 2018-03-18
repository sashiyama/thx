json.thx_hash @thx_transaction.thx_hash
json.sender do
  json.name @thx_transaction.sender.name
  json.address @thx_transaction.sender.address
  json.verified @thx_transaction.sender.verified
end
json.receiver do
  json.name @thx_transaction.receiver.name
  json.address @thx_transaction.receiver.address
  json.verified @thx_transaction.receiver.verified
end
json.thx @thx_transaction.thx
json.comment @thx_transaction.comment
json.created_at @thx_transaction.created_at.strftime("%Y/%m/%d %H:%M")