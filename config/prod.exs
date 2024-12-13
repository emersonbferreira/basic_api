import Config

#Database
config :basic_api, BasicApi.Repo,
  url: System.get_env("DATABASE_URL"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


# Configures Swoosh API Client
config :swoosh, :api_client, false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
