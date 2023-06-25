class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def status_email(parcel)
    @parcel = parcel
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url = 'http://localhost:3000/search'
    mail(to: @receiver.email, cc: @sender.email, subject: 'New Parcel Information Tracking Number')
  end
end
