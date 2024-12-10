# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :basic_api,
  ecto_repos: [BasicApi.Repo],
  generators: [timestamp_type: :utc_datetime]

config :basic_api, BasicApi.Models.Guardian,
  issuer: "basic_api",
  secret_key: "abuNKdvJmQ38fpYZaz6Lw0Ay446yR0i0pi2aSKuy+bkuZbWfd4T0JSumYmCkQ20N"

# Configures the endpoint
config :basic_api, BasicApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: BasicApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BasicApi.PubSub,
  live_view: [signing_salt: "8MXk+c90"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :basic_api, BasicApi.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"