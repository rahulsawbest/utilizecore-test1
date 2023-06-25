class ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    # Generate the report and send it as a response
    send_data generate_report, filename: report_filename, type: Mime[:xlsx]
  end

  private

  def generate_report
    # Get the parcels, along with associated sender and receiver details
    parcels = Parcel.includes(:sender, :receiver)

    # Create a new workbook
    workbook = Axlsx::Package.new
    workbook.use_shared_strings = true

    # Add a worksheet to the workbook
    workbook.workbook.add_worksheet(name: 'Parcels') do |sheet|
      # Add headers to the worksheet
      sheet.add_row ['Tracking Number', 'Sender Name', 'Sender Address', 'Receiver Name', 'Receiver Address']

      # Add data rows to the worksheet
      parcels.each do |parcel|
        sheet.add_row [
          parcel.tracking_number,
          parcel.sender.name,
          parcel.sender.address,
          parcel.receiver.name,
          parcel.receiver.address
        ]
      end
    end

    # Serialize the workbook to a byte stream and return it
    workbook.to_stream.read
  end

  def report_filename
    "parcels_report_#{Time.zone.today.to_s}.xlsx"
  end

  # Check if the current user is an admin
  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
end
