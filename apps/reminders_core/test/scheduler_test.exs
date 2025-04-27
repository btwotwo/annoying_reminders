defmodule SchedulerTest do
  use ExUnit
  alias RemindersCore.Scheduler
  alias RemindersCore.Data.Reminder

  test "Scheduler creates valid tasks" do
    reminder = create_reminder()
    {:ok} = reminder |> Scheduler.schedule_reminder()
  end

  defp create_reminder() do
    Reminder.new(%{
      user_id: 0,
      id: 1,
      text: "ReminderText",
      firing_time: Time.new(12, 0, 0),
      firing_period: :daily,
      firing_window: 5000,
      nagging_interval: 500,
    })
  end
end