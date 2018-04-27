  module SlackHelper

    require 'slack'

    def error_msg(user_id, channel_id)
      Slack.configure do |config|
        config.token = ENV['WORK_SPACE_TOKEN']
      end

      Slack.chat_postEphemeral(
        channel: channel_id,
        text: " :scream: 送信に失敗しました。以下のフォーマットで入力してください。\n\n /thx    @送り先ユーザー名    thxポイント(数字)   メッセージ",
        user: user_id
      )
    end

    def success_msg(user_id, channel_id)
      Slack.configure do |config|
        config.token = ENV['WORK_SPACE_TOKEN']
      end

      Slack.chat_postEphemeral(
        channel: channel_id,
        text: " :ok_hand: 正常に送信完了しました",
        user: user_id
      )
    end

    def time_line_msg(receiver, thx, comment)
      Slack.configure do |config|
        config.token = ENV['WORK_SPACE_TOKEN']
      end

      Slack.chat_postMessage({
        "channel": '#thxタイムライン',
        "color": 'red',
        "text": ":small_red_triangle_down: \n *#{receiver}* へ \n 「#{comment}」\n + #{thx} thx :gift:",
        "attachments": [
          {
            "text": "",
            # "callback_id": "wopr_game",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
              {
                "name": "clap",
                "text": " :clap: × 1",
                "type": "button",
                "value": "1"
              },
              {
                "name": "clap",
                "text": " :clap: × 3",
                "type": "button",
                "value": "3"
              },
              {
                "name": "clap",
                "text": " :clap: × 5",
                "type": "button",
                "value": "5"
              }
            ]
          }
        ],
        "as_user": true}
        )
    end

    def params_parser(st_params)
      binding.pry
      # display_nameはreceiverのslackユーザーの表示名
      display_name, thx, comment = st_params[:text].match(/\A@(?<display_name>.+)\s(?<thx>\d+)\s(?<comment>.+)\z/).captures
      slack_user_id              = st_params[:user_id]
      current_channel_id         = st_params[:channel_id]

      # データベースにデータがまだない
      # heroku上でテストしたいのでコメントアウトする
      # sender                   = SlackUser.find_by(slack_user_id: slack_user_id)
      # receiver                 = SlackUser.find_by(display_name: display_name)

      # herokuテスト用
      time_line_msg(display_name, thx, comment)
      success_msg(slack_user_id, current_channel_id)

      # heroku上でテストしたいのでコメントアウトする
      # [sender, receiver, thx.to_i, comment]

      # herokuテスト用
      [slack_user_id, display_name, thx.to_i, comment]
    rescue => ex
      error_msg(slack_user_id, current_channel_id)
    end
  end
