namespace :notification do
  desc 'sends notifications'
  task send_ready_to_send: :environment do
    Notification::Send.call
  end
end
