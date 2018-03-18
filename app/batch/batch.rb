# バッチ関連の共通処理定義
module Batch
  extend ActiveSupport::Concern
  included do
    @logger = Logger.new(Rails.root.join("log", "#{Rails.env}.log"))
  end
end