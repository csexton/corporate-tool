Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    name: 'google',
    #access_type: 'offline',
    #approval_prompt: 'auto',
    #hd: 'radiusnetworks.com',
    # Trying to get the Hosted Domain param to work
    # https://github.com/zquestz/omniauth-google-oauth2/pull/29
    # https://github.com/gitlabhq/gitlabhq/issues/1635
  }
end
