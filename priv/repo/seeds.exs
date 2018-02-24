# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExLog.Repo.insert!(%ExLog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExLog.Logging.Level

# Adding the basic log levels

ExLog.Repo.insert!(%Level{name: "TRACE", priority: 0})
ExLog.Repo.insert!(%Level{name: "DEBUG", priority: 10})
ExLog.Repo.insert!(%Level{name: "INFO", priority: 20})
ExLog.Repo.insert!(%Level{name: "WARN", priority: 30})
ExLog.Repo.insert!(%Level{name: "ERROR", priority: 40})
ExLog.Repo.insert!(%Level{name: "CRITICAL", priority: 50})
