# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :newsfeed,
  ecto_repos: [Newsfeed.Repo]

# Configures the endpoint
config :newsfeed, NewsfeedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7ddmBCL/G6Z3GXprt+qhArmY5xUpc25YaEtEQTCJek4FULgXo+BP0KaFvrCS2wUG",
  render_errors: [view: NewsfeedWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Newsfeed.PubSub,
  live_view: [signing_salt: "Yn/6xlMM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaffe,
  consumer: [
    endpoints: [{"redpanda", 9092}],  # Using the hostname from docker-compose
    topics: ["newsfeed"],     # the topic(s) that will be consumed
    consumer_group: "learning-elixir",   # the consumer group for tracking offsets in Kafka
    message_handler: Newsfeed.KafkaConsumer   # the module that will process messages
  ],
  producer: [
    endpoints: [{"redpanda", 9092}],
    topics: ["newsfeed"]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
