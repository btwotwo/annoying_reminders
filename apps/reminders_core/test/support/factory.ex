defmodule RemindersCore.Factory do
  require ExUnitProperties
  alias RemindersCore.Data.Reminder

  def reminder_generator(user_id) do
    ExUnitProperties.gen all(
                           text <- StreamData.string(:printable),
                           firing_time <- time_generator(),
                           firing_period <- :daily,
                           firing_window <-
                             StreamData.one_of([
                               StreamData.non_negative_integer(),
                               StreamData.constant(nil)
                             ]),
                           nagging_interval <- StreamData.non_negative_integer(),
                           ack_delay <-
                             StreamData.one_of([
                               StreamData.non_negative_integer(),
                               StreamData.constant(nil)
                             ])
                         ) do
      %Reminder{
        text: text,
        firing_time: firing_time,
        firing_period: firing_period,
        firing_window: firing_window,
        nagging_interval: nagging_interval,
        ack_delay: ack_delay,
        state: :pending,
        user_id: user_id
      }
    end
  end

  defp time_generator() do
    ExUnitProperties.gen all(
                           hour <- StreamData.integer(0..23),
                           minute <- StreamData.integer(0..59),
                           second <- StreamData.integer(0..59)
                         ) do
      Time.new!(hour, minute, second)
    end
  end
end
