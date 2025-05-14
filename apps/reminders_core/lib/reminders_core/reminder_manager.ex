defmodule RemindersCore.ReminderManager do
  use GenServer
  alias RemindersCore.Data.Reminder
  alias RemindersCore.Data.Reminder.Store

  @impl true
  def init(user_id) do
    now = DateTime.utc_now()
    reminders = Store.get(user_id, schedulable_states()) |> Enum.group_by(& &1.state)
    timers = schedulable_states() |> Enum.map(&create_timers_for(reminders, &1, now))

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
      target_time = target_time(r, now)
      message = target_message(r)
      timer_ref = schedule_at(target_time, message, now, self())

      {r.id, timer_ref}
    end)
  end


  @spec schedule_at(DateTime.t(), any(), DateTime.t(), pid()) :: reference()
  defp schedule_at(time, message, now, dest) do
    target_delay = DateTime.diff(time, now, :millisecond)
    Process.send_after(dest, message, target_delay)
  end

  defp schedulable_states(), do: [:scheduled, :nagging, :acking]
  
  defp target_message(%Reminder{state: :scheduled} = r), do: {:trigger, r}
  defp target_message(%Reminder{state: :nagging} = r), do: {:nag, r}
  defp target_message(%Reminder{state: :acking} = r), do: {:ack, r}

  def target_time(%Reminder{state: :scheduled} = reminder, now),
    do: Reminder.get_schedule_time(reminder, now)
  def target_time(%Reminder{state: :nagging} = reminder, now), do: Reminder.get_nag_time(reminder, now)
  def target_time(%Reminder{state: :acking} = reminder, now), do: Reminder.get_ack_time(reminder, now)

end
