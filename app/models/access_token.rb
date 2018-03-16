class AccessToken < ApplicationRecord
  belongs_to :user

  ACCESS_TOKEN_LIMIT_MIN = 30
  REFRESH_TOKEN_LIMIT_MONTHS = 6

  def self.generate_token(user, auto_login)
    access_token = AccessToken.find_by(user: user)
    if access_token.present?
      access_token.update!(token: SecureRandom.hex, refresh_token: SecureRandom.hex, issued_at: Time.zone.now, refresh_token_issued_at: Time.zone.now)
    else
      access_token = AccessToken.new(user: user, token: SecureRandom.hex, refresh_token: SecureRandom.hex, issued_at: Time.zone.now, refresh_token_issued_at: Time.zone.now)
      begin
        access_token.save!
      rescue
        retry
      end
    end
    if auto_login
      {
        access_token: access_token.token,
        refresh_token: access_token.refresh_token,
        expires_at: access_token.expires_at
      }
    else
      {
        access_token: access_token.token,
        expires_at: access_token.expires_at
      }
    end
  end

  def self.refresh_token token
    access_token = find_by(refresh_token: token)
    if access_token.present? && !access_token.refresh_token_expired?
      access_token.update!(token: SecureRandom.hex, issued_at: Time.zone.now)
      access_token
    else
      false
    end
  end

  def expired?
    Time.zone.now >= expires_at
  end

  def expires_at
    issued_at + ACCESS_TOKEN_LIMIT_MIN.minutes
  end

  def refresh_token_expired?
    Time.zone.now >= refresh_token_expires_at
  end

  def refresh_token_expires_at
    refresh_token_issued_at + REFRESH_TOKEN_LIMIT_MONTHS.months
  end
end
