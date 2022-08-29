import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :keybored_ui, KeyboredUIWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0NLcF+PTli6WzwYBhFiBIFDa90CXGMt3TfZnB4yEGGpi1DSZS8Y77JpBb66uAV38",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
