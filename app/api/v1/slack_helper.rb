  module SlackHelper

    require 'slack'

    def error_msg(user_id, channel_id)
      Slack.configure do |config|
        config.token = ENV['WORK_SPACE_TOKEN']
      end

      Slack.chat_postEphemeral(
        channel: channel_id,
        text: "thxを送れませんでした。以下のフォーマットで入力してください。\n\n/thx    @送り先ユーザー名    thxポイント(数字)   メッセージ",
        icon_emoji: ':exclamation:',
        user: user_id
      )
    end

    def params_parser(st_params)
      # receiver_nameはreceiverのslack上でのユーザー名
      receiver_name, thx, comment = st_params[:text].match(/\A@(?<receiver_name>.+)\s(?<thx>\d+)\s(?<comment>.+)\z/).captures

      send_slack(comment)

      sender = SlackUser.find_by(slack_user_id: st_params[:user_id]).user
      receiver = SlackUser.find_by(user_name: receiver_name).user

      [sender, receiver, thx.to_i, comment]
    rescue => ex
      error_msg(st_params[:user_id], st_params[:channel_id])
    end

    def send_slack(comment)
      notifier = Slack::Notifier.new("https://hooks.slack.com/services/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")
      payload = attachments(comment)
      notifier.ping(payload)
    end

    def attachments(comment)
      {
          "text": "new thx",
          "attachments": [
              {
                  "text":"#{comment}"
              }
          ]
      }
      # {
      #   "attachments": [
      #     {
      #       "color": "#36a64f",
      #       "pretext": "*#{thxes.sender.name}* から *#{thxes.receiver.name}* に *#{thxes.thx}* thx送られました",
      #       "mrkdwn_in": ["text", "pretext"],
      #       "fields": [
      #         {
      #           "title": "comment",
      #           "value": "#{thxes.comment}",
      #           "short": false
      #         }
      #       ]
      #     }
      #   ]
      # }

    end
  end
