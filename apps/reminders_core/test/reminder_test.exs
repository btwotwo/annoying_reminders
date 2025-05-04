defmodule ReminderTest do
  alias RemindersCore.Data.Reminder
  use ExUnit.Case
  use ExUnitProperties
  doctest RemindersCore.Data.Reminder

  property "target firing time is today or tomorrow, but always in the future" do
    check all now <- DateTimeGenerators.datetime(),
              offset <- StreamData.integer(-86400..86400),
              firing_time = DateTime.add(now, offset, :second) do
      
      reminder = %Reminder{
        firing_time: firing_time,
        firing_period: :daily
      }

      target_time = Reminder.get_target_time(reminder, now)
      assert DateTime.compare(target_time, now) != :lt
      assert DateTime.diff(target_time, firing_time, :second) in [0, 86400]
    end
  end
end