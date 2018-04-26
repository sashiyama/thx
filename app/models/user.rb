class User < ApplicationRecord
  has_one :user
  has_many :receivers,  class_name:  'ThxTransaction',
           foreign_key: 'receiver_id'
  has_many :senders,  class_name:  'ThxTransaction',
           foreign_key: 'sender_id'
  has_one :access_token, class_name: 'AccessToken', dependent: :destroy, inverse_of: :user

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
  validates :name, length: { maximum: 100 }
  validates :thx_balance, numericality: { greater_than_or_equal_to: 0, message: "が%{count}を下回っています" }
  validates :received_thx, numericality: { greater_than_or_equal_to: 0 }
  has_secure_password

  enum status: {
    enable: 'enable',
    disable: 'disable'
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
