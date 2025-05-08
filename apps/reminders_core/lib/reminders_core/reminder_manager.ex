defmodule RemindersCore.ReminderManager do
  use GenServer
  alias RemindersCore.Data.Reminder
  alias RemindersCore.Data.Reminder.Store
  alias RemindersCore.Data.Reminder.Repo

  @impl true
  def init(user_id) do
    now = DateTime.utc_now()
    reminders = Store.get_schedulable_reminders(user_id) |> Enum.group_by(& &1.state)

    schedule_timers =
      Map.get(reminders, :scheduled, [])
      |> Enum.map(fn r ->
        target_time = Reminder.get_schedule_time(r, now)
        timer_ref = schedule_at(target_time, {:trigger, r}, now, self())

        {r.id, timer_ref}
      end)

    nag_timers =
      Map.get(reminders, :nagging, [])
      |> Enum.map(fn r ->
        target_time = Reminder.get_nag_time(r, now)
        timer_ref = schedule_at(target_time, {:nag, r}, now, self())

        {r.id, timer_ref}
      end)

    ack_timers =
      Map.get(reminders, :acking, [])
      |> Enum.map(fn r ->
        target_time = Reminder.get_ack_time(r, now)
        timer_ref = schedule_at(target_time, {:ack, r}, now, self())

        {r.id, timer_ref}
      end)

    {:ok, Enum.concat([schedule_timers, nag_timers, ack_timers])}
  end

  def schedule_reminder(reminder_id, pid) do
  end

  def confirm_reminder(reminder_id, pid) do
  end

  def acknowledge_reminder(reminder_id, pid) do
  end

  def schedule_at(time, message, now, dest) do
    target_delay = DateTime.diff(time, now, :millisecond)
    Process.send_after(dest, message, target_delay)
  end
end
