# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :api_sandbox, ApiSandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1eJLQuZuCUbDkADbdj+KNhzy9JXoh1fyOpui+0daD/MnXvk+QsMmaory6P1RQnE0",
  render_errors: [view: ApiSandboxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ApiSandbox.PubSub,
  live_view: [signing_salt: "z9f9vlpA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
