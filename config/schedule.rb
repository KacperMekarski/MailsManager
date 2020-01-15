every '1 1 1 * *' do
  rake "sheet:create_monthly"
end

every '1 * * * *' do
  rake "sheet:map_data"
end

every '30 * * * *' do
  rake "sheet:map_data"
end
