Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shibboleth
  provider :developer, fields: [:uid, :email, :invitation_token] unless Rails.env.production?
end
