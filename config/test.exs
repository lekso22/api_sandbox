use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_sandbox, ApiSandboxWeb.Endpoint,
  http: [port: 4002],
  server: false

config :api_sandbox,
  url: "http://localhost:4002"


# Print only warnings and errors during test
config :logger, level: :warn
