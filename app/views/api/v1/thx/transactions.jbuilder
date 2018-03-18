json.thx_transactions @thx_transactions do |thx|
  json.thx_hash thx.thx_hash
  json.sender do
    json.name thx.sender.name
    json.address thx.sender.address
    json.verified thx.sender.verified
  end
  json.receiver do
    json.name thx.receiver.name
    json.address thx.receiver.address
    json.verified thx.receiver.verified
  end
  json.thx thx.thx
  json.comment thx.comment
  json.created_at thx.created_at.strftime("%Y/%m/%d %H:%M")
end
