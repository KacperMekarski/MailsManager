Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development? || Rails.env.test?
end
