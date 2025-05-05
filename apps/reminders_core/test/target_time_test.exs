defmodule ReminderTest do
  alias RemindersCore.Data.Reminder
  use ExUnit.Case
  use ExUnitProperties
  doctest RemindersCore.Data.Reminder

  property "target firing time is in the future in the same time" do
    check all(
            now <- DateTimeGenerators.datetime(),
            firing_time <- DateTimeGenerators.time()
          ) do
      reminder = %Reminder{
        firing_time: firing_time,
        firing_period: :daily
      }

      target_time = Reminder.get_target_time(reminder, now)
      assert DateTime.compare(target_time, now) != :lt
      assert DateTime.to_time(target_time) == firing_time
    end
  end
end
