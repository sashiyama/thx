class GiveThx
  include Batch

  def self.run
    @logger.info "[start] give thx"
    giving_history = GivingHistory.order("id desc").limit(1)
    if giving_history.blank? || (giving_history.first.giving_date + GivingHistory::GIVING_PERIOD) <= Time.zone.today
      ApplicationRecord.transaction do
        User.enable.update_all(thx_balance: 0)
        User.enable.update_all(thx_balance: User::INIT_THX)
        GivingHistory.create!(giving_date: Time.zone.today)
      end
    end
  rescue => e
    @logger.error "[error] #{e.inspect}\n#{e.backtrace.join("\n")}"
  ensure
    @logger.info "[end] give thx"
  end

end
