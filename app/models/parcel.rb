class Parcel < ApplicationRecord
  attr_accessor :tracking_number

  STATUS = ['Sent', 'In Transit', 'Delivered'].freeze
  PAYMENT_MODE = %w[COD Prepaid].freeze

  validates :weight, :status, presence: true
  validates :status, inclusion: STATUS
  validates :payment_mode, inclusion: PAYMENT_MODE

  belongs_to :service_type
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  before_create :get_tracking_number
  after_create :send_notification

  private

  def send_notification
    UserMailer.with(parcel: self).status_email.deliver_later
  end

  def get_tracking_number
    self.tracking_number = SecureRandom.uuid
  end
end
