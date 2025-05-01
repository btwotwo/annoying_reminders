defmodule RemindersCore.Data.Repo do
  use Ecto.Repo,
    otp_app: :reminders_core,
    adapter: Ecto.Adapters.Postgres
end
