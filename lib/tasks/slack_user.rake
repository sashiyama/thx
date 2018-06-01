# encoding: utf-8
namespace :slack_user do
  desc "import slack user"
  task :import => :environment do
    res = Net::HTTP.get(URI.parse("https://slack.com/api/users.list?token=#{ENV['SLACK_TOKEN']}&pretty=1"))
    return if res.blank?
    pretty_res = JSON.parse(res)
    User.where(slack_team_id: pretty_res['members'][0]['team_id']).destroy_all
    slack_users = []
    pretty_res['members'].each do |user|
      slack_users << User.new(name: user['name'],
                              email: user['profile']['email'],
                              slack_user_id: user['id'],
                              slack_team_id: user['team_id'],
                              address: SecureRandom.hex,
                              thx_balance: User::INIT_THX,
                              password: User::SLACK_USER_DUMMY_PASSWORD,
                              password_confirmation: User::SLACK_USER_DUMMY_PASSWORD,
                              verified: true)
    end
    User.import slack_users
  end
end