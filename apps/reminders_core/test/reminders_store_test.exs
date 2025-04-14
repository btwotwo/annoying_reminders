defmodule RemindersStoreTest do
  alias RemindersCore.Reminder
  use ExUnit.Case

  defp create_reminder() do
    %Reminder {
      id: 1,
      user_id: "user",
      text: "Reminder1",
      firing_time: Time.new(12, 0, 0),
      firing_period: :daily,
      firing_window: 6000,
      nagging_interval: 6000
    }
  end
end
