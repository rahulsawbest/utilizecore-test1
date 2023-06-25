env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

# Schedule the report generation task
every 1.day, at: '00:00 am' do
  rake 'reports:generate'
end