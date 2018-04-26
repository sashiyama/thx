  module SlackHelper

    def params_parser(st_params)
      # receiver_nameはreceiverのslack上でのユーザー名
      receiver_name, thx, comment = st_params[:text].match(/@(?<receiver_name>.+)\s(?<thx>.+)\s(?<comment>.+)/).captures

      sender = SlackUser.find_by(slack_user_id: st_params[:user_id]).user
      receiver = SlackUser.find_by(user_name: receiver_name).user

      [sender, receiver, thx.to_i, comment]
    end

    def send_time_line(thxes)
      notifier = Slack::Notifier.new(WEB_HOOK_URL)
      payload = attachments(thxes)
      notifier.ping(payload)
    end

    def attachments(thxes)
      {
        "attachments": [
          {
            "color": "#36a64f",
            "pretext": "*#{thxes.sender.name}* から *#{thxes.receiver.name}* に *#{thxes.thx}* thx送られました",
            "mrkdwn_in": ["text", "pretext"],
            "fields": [
              {
                "title": "comment",
                "value": "#{thxes.comment}",
                "short": false
              }
            ]
          }
        ]
      }
    end
  end
