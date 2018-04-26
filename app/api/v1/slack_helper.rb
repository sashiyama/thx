  module SlackHelper

    def params_parser(st_params)
      # receiver_nameはreceiverのslack上でのユーザー名
      receiver_name, thx, comment = st_params[:text].match(/@(?<receiver_name>.+)\s(?<thx>.+)\s(?<comment>.+)/).captures

      sender = SlackUser.find_by(slack_user_id: st_params[:user_id]).user
      receiver = SlackUser.find_by(user_name: receiver_name).user

      [sender, receiver, thx.to_i, comment]
    end

    def send_slack(thxes)
      notifier = Slack::Notifier.new("https://hooks.slack.com/services/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")
      payload = attachments(thxes)
      notifier.ping(payload)
    end

    def attachments(thxes)
      {
          "text": "It's 80 degrees right now.",
          "attachments": [
              {
                  "text":"Partly cloudy today and tomorrow"
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
