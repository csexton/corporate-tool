# Be sure to restart your server when you modify this file.

# expire_after is an idle timeout: the cookie store re-issues the cookie on
# every request, so an active session keeps sliding forward. The absolute
# limit (ApplicationController::SESSION_MAX_AGE) forces a fresh Google
# sign-in, which is what actually cuts off people who have left.
Rails.application.config.session_store :cookie_store,
  key: '_corporate_tool_session',
  expire_after: 2.weeks
