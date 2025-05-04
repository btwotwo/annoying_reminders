defmodule RemindersCore.Data.User do
  use Ecto.Schema

  schema "users" do
    has_many(:reminders, RemindersCore.Data.Reminder)
    timestamps()
  end
end
