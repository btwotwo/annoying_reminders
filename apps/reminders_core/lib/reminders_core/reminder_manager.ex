defmodule RemindersCore.ReminderManager do
  use GenServer
  alias RemindersCore.Data.Reminder.Store
  alias RemindersCore.Data.Reminder.ReminderState
  alias RemindersCore.Data.Reminder.Repo

  @impl true
  def init(user_id) do
    states = Store.get_schedulable_states(user_id)
    
  end

  def schedule_reminder(reminder_id, pid) do
  end

  def confirm_reminder(reminder_id, pid) do
  end

  def acknowledge_reminder(reminder_id, pid) do
  end
end
