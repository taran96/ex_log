# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_log,
  ecto_repos: [ExLog.Repo]

# Configures the endpoint
config :ex_log, ExLogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8jt//Lbxip4GB4j1tLuN62Ns1FxpWeeTOBwE8F+gZ7dHCIgepVAngAGbCw3qA+hr",
  render_errors: [view: ExLogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExLog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Ex Admin
config :ex_admin,
  repo: ExLog.Repo,
  module: ExLogWeb,
  modules: [
    ExLog.ExAdmin.Dashboard,
    ExLog.ExAdmin.Service,
    ExLog.ExAdmin.Level,
    ExLog.ExAdmin.Entry,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

