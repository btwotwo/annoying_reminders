defmodule RemindersCore.ReminderManager do
  use GenServer
  alias RemindersCore.Data.Reminder
  alias RemindersCore.Data.Reminder.Store
  alias RemindersCore.Data.Reminder.Repo

  @impl true
  def init(user_id) do
    now = DateTime.utc_now()
    reminders = Store.get_schedulable_reminders(user_id) |> Enum.group_by(& &1.state)
    timers = Reminder.schedulable_states() |> Enum.map(&create_timers_for(reminders, &1, now))

    {:ok, timers}
  end

  def schedule_reminder(reminder_id, pid) do
  end

  def confirm_reminder(reminder_id, pid) do
  end

  def acknowledge_reminder(reminder_id, pid) do
  end

  defp create_timers_for(reminders, state, now) do
    Map.get(reminders, state, [])
    |> Enum.map(fn r ->
      target_time = Reminder.target_time(r, now)
      message = target_message(r)
      timer_ref = schedule_at(target_time, message, now, self())

      {r.id, timer_ref}
    end)
  end

  defp target_message(%Reminder{state: :scheduled} = r), do: {:trigger, r}
  defp target_message(%Reminder{state: :nagging} = r), do: {:nag, r}
  defp target_message(%Reminder{state: :acking} = r), do: {:ack, r}

  @spec schedule_at(DateTime.t(), any(), DateTime.t(), pid()) :: reference()
  defp schedule_at(time, message, now, dest) do
    target_delay = DateTime.diff(time, now, :millisecond)
    Process.send_after(dest, message, target_delay)
  end
end
