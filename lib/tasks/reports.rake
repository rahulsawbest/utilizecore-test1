namespace :reports do
  desc 'Generate daily report'
  task generate: :environment do
    # Create an instance of the ReportsController
    reports_controller = ReportsController.new

    # Generate the report
    report_data = reports_controller.send(:generate_report)

    # Write the report to a file
    filename = reports_controller.send(:report_filename)
    File.open(filename, 'wb') { |file| file.write(report_data) }

    puts "Report generated: #{filename}"
  end
end
