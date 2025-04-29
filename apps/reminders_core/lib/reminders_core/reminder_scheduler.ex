defmodule RemindersCore.ReminderScheduler do
  alias RemindersCore.Data.Reminder
  use GenServer

  @impl true
  def init(_) do
    reminders = Reminder.Store.get_all()
  end
end
