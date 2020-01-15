namespace :sheet do
  desc 'create new sheet for current month'
  task create_monthly: :environment do
    Sheet::CreateMonthly.call
  end

  desc 'map data from sheet'
  task map_data: :environment do
    Notification::CreateFromLastSheet.call
  end
end
