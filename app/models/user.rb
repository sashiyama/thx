class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, presence: true,
            format: { with: VALID_EMAIL_REGEX }
  validates_format_of :password, :with => /\A.*[a-zA-Z]+.*\z/,
                      :allow_blank => true, :on => [:create, :update],
                      :message => "は英字を1文字以上含めてください"
  validates_format_of :password, :with => /\A.*[0-9]+.*\z/,
                      :allow_blank => true, :on => [:create, :update],
                      :message => "は数字を1文字以上含めてください"
  validates_format_of :password, :with => /\A[ -~。-゜]*\z/,
                      :on => [:create, :update],
                      :message => "は半角で入力してください"
  has_secure_password

  enum status: {
    enabled: 'enable',
    disabled: 'disable'
  }

  before_create do
    if User.where(status: [:enable, :disable], email: self.email).present?
      self.errors.add(:email, "はすでに登録済みです")
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  # 初回登録時自動付与thx
  INIT_THX = 1000
end
