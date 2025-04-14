defmodule RemindersCore.Reminder do
	
  @moduledoc """
  It can be either standalone, or contain a list of `RemindersCore.Confirmation` that will trigger additional reminders after this one is completed.
  An example reminder is "Did you eat?" that triggers daily at 12:00 with randomised 15-minute interval. One of confirmations is "Yes" that triggers another reminder "Did you eat pills?"
  """
  @enforce_keys [:id, :text, :firing_time, :firing_period, :firing_window]
  defstruct [
    :id,
    :text,
    :firing_time,
    :firing_period,
    :firing_window,
    user_id: 0,
    nagging_interval: 600
  ]

  @typedoc """
  A reminder with the following fields:
  - `id`: Unique ID of reminder
  - `text`: Reminder text (e.g "Did you eat?")
  - `firing_time`: Time of day when reminder should fire.
  - `firing_period`: How often the notification should be triggered.
  - `firing_window`: Randomized time windows size. For example, if you set `firing_time` to 12:00 and window size to 15 mins, so it will randomly fire between 11:45 and 12:15.
  - `nagging_interval`: Period indicating how often the notification should be resent. Defined in milliseconds, default value is 600.
  """
  @type t :: %__MODULE__{
          id: any(),
          user_id: any(),
          text: String.t(),
          firing_time: Time.t(),
          firing_period: :daily,
          firing_window: pos_integer(),
          nagging_interval: pos_integer()
        }

  def new(attrs)
      when is_binary(attrs.text) and byte_size(attrs.text) > 0
      when is_struct(attrs.firing_time, Time)
      when attrs.firing_period in [:daily]
      when is_number(attrs.firing_window)
      when is_number(attrs.nagging_interval) and attrs.nagging_interval > 1000 do
    struct!(__MODULE__, attrs)
  end

end
