defmodule RemindersCore.Data.Reminder do
  use Ecto.Schema

  @moduledoc """
  It can be either standalone, or contain a `Confirmation` that will trigger additional reminder after this one is completed.
  """
  schema "reminders" do
    field(:text, :string)
    field(:firing_time, :time)
    field(:firing_period, Ecto.Enum, values: [:daily])
    field(:firing_window, :integer)
    field(:nagging_interval, :integer, default: 10000)
    field(:ack_delay, :integer)
    timestamps()
    has_one(:state, RemindersCore.Data.Reminder.ReminderState)
    belongs_to(:user, RemindersCore.Data.User)
  end

  @typedoc """
  A reminder with the following fields:
  - `id`: Unique ID of reminder
  - `text`: Reminder text (e.g "Did you eat?")
  - `firing_time`: Time of day when reminder should fire.
  - `firing_period`: How often the notification should be triggered (e.g `:daily`)
  - `firing_window`: Randomized time windows size. For example, if you set `firing_time` to 12:00 and window size to 15 mins, so it will randomly fire between 11:45 and 12:15.
  - `nagging_interval`: Period indicating how often the notification should be resent. Defined in milliseconds, default value is 10000.
  - `acknowledge_delay`: Delay before sending an acknowledgment notification. Optional.
  """
  @type t :: %__MODULE__{
          id: any(),
          user_id: any(),
          text: String.t(),
          firing_time: Time.t(),
          firing_period: :daily | nil,
          firing_window: pos_integer() | nil,
          nagging_interval: pos_integer(),
          ack_delay: pos_integer() | nil
        }

  def changeset(reminder, params \\ %{}) do
    reminder
    |> Ecto.Changeset.cast(params, [
      :text,
      :firing_time,
      :firing_period,
      :firing_window,
      :nagging_interval
    ])
    |> Ecto.Changeset.validate_required([:text, :firing_time, :firing_period])
  end
end
