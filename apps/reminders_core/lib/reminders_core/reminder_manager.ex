defmodule RemindersCore.ReminderManager do
  use GenServer
  alias RemindersCore.Data.Reminder.Store
  alias RemindersCore.Data.Reminder.ReminderState
  alias RemindersCore.Data.Reminder.Repo

  @impl true
  def init(user_id) do
    reminders = Store.get_schedulable_reminders(user_id) |> Enum.reject(&(&1.last_sent_at == nil)) 
  end

  def schedule_reminder(reminder_id, pid) do
  end

  def confirm_reminder(reminder_id, pid) do
  end

  def acknowledge_reminder(reminder_id, pid) do
  end
end
