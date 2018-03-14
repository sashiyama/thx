json.users @users do |user|
  json.name user.name
  json.address user.address
  json.verified user.verified
end
