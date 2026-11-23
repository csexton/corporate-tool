# Puma configuration. See https://puma.io/puma/Puma/DSL.html
#
# MAX_THREADS is kept for compatibility with the existing Heroku config.
threads_count = ENV.fetch("RAILS_MAX_THREADS") { ENV.fetch("MAX_THREADS", 5) }
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

workers ENV.fetch("WEB_CONCURRENCY", 2)
preload_app!

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
