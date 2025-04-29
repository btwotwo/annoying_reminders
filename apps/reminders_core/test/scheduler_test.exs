defmodule SchedulerTest do
  use ExUnit.Case
  alias RemindersCore.Scheduler
  alias RemindersCore.Data.Reminder

  test "scheduler does not accept date in the past" do
  end

  test "scheduler correctly executes tasks" do
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