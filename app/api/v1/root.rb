module Root
  class V1 < Grape::API
    helpers SlackHelper
    # ex) http://api.localhost.local:3000/v1
    version 'v1', :using => :path
    helpers do
      def enable_user
        User.enable
      end

      def bearer_token
        pattern = /^Bearer /
        header  = request.headers["Authorization"]
        error_format('Access Token is missing.', '', 401, 'WWW-Authenticate' => "Bearer realm='#{Global.hosts.api}'") if header.blank?
        header.gsub(pattern, '') if header && header.match(pattern)
      end

      def checked_token
        access_token = AccessToken.find_by(token: bearer_token)
        if access_token.blank? || access_token.expired?
          error_format('Invalid Access Token.', '', 401, 'WWW-Authenticate' => 'Bearer error="invalid_request"')
        else
          access_token
        end
      end

      def current_user
        user = checked_token.user
        if user.disable?
          access_denied
        else
          user
        end
      end

      def user_signed_in?
        user = checked_token.user
        if user.disable?
          access_denied
        else
          true
        end
      end
    end
    namespace do
      mount Users::V1
    end
  end
end
