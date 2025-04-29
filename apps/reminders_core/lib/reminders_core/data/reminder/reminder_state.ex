defmodule RemindersCore.Data.Reminder.ReminderState do
  use Ecto.Schema

  schema "reminder_states" do
    field(:state, Ecto.Enum, values: [:pending, :scheduled, :fired])
    belongs_to(:reminder, RemindersCore.Data.Reminder.Reminderv2)
  end
end