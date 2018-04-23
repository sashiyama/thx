module SlackApp

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
