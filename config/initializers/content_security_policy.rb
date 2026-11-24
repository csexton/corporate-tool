# Be sure to restart your server when you modify this file.

# Content Security Policy: a second layer behind the markdown sanitizer. If
# HTML ever gets through into a page, the browser still refuses to run
# inline or third-party scripts.
#
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    # Only our own compiled bundle. The one inline script (the iframe upload
    # callback) carries a per-request nonce.
    policy.script_src  :self
    # Markdown allows style attributes, and mermaid injects <style> into its
    # SVGs, so inline styles have to stay allowed.
    policy.style_src   :self, :unsafe_inline
    # Pages embed images from S3 uploads, Gravatar and anywhere else on https.
    policy.img_src     :self, :https, :data
    policy.font_src    :self, :data
    policy.connect_src :self
    policy.frame_src   :self
    policy.object_src  :none
    policy.base_uri    :self
    # Signing in posts to /auth/google, which redirects to Google; browsers
    # check form-action against redirects too.
    policy.form_action :self, "https://accounts.google.com"
    policy.frame_ancestors :self
  end

  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
end
