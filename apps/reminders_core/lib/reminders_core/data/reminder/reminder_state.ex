defmodule RemindersCore.Data.Reminder.ReminderState do
  use Ecto.Schema
  @moduledoc """
  Current state of the reminder. Updated by `RemindersCore.ReminderManager`. Every reminder has only one state record.
  """
  
  schema "reminder_states" do
    field(:state, Ecto.Enum, values: [:pending, :scheduled, :fired])
    belongs_to(:reminder, RemindersCore.Data.Reminder)
  end
end
