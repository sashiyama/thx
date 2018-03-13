module Endpoint
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    helpers do
      def error_format(dev_msg, user_msg, code, header=nil)
        if header.present?
          error!({developerMessage: dev_msg, userMessage: user_msg}, code, header)
        else
          error!({developerMessage: dev_msg, userMessage: user_msg}, code)
        end
      end

      def not_found_error(dev_msg = 'Not Found', user_msg = '指定されたものは見つかりません。')
        error_format(dev_msg, user_msg, 404)
      end

      def access_denied
        error_format('Access is denied.', 'アクセスが許可されていません。', 403)
      end

      def failed_to_save
        error_format('Failed to save data', 'データの保存に失敗しました。', 503)
      end

      def failed_to_delete
        error_format('Failed to delete.', 'データの削除に失敗しました。', 503)
      end

      def validation_error(dev_msg, user_msg)
        error_format(dev_msg, user_msg, 400)
      end

      def strong_params params
        ActionController::Parameters.new(params)
      end

      def handle_log
        begin
          yield
        rescue Exception => e
          Rails.logger.error e.message
        end
      end
    end

    route :any, '*path' do
      not_found_error
    end

    route :any do
      not_found_error
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      not_found_error
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error_format(e.message, e.message, 400)
    end

    rescue_from ActiveRecord::RecordInvalid, ArgumentError do |e|
      error_format(e.message, e.message, 400)
    end

    rescue_from :all do |e|
      if e.cause.class == Mysql2::Error
        error_format('Database error occurred', '予期せぬエラーが発生しました。', 500)
      else
        error_format(e.message, '予期せぬエラーが発生しました。', 500)
      end
    end

    mount Root::V1
  end
end
