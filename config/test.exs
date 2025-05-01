import Config

config :reminders_core, RemindersCore.Data.Repo,
  username: "postgres",
  password: "1234",
  database: "reminders_core_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
