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
    field(:state, Ecto.Enum, values: [:pending, :scheduled, :nagging, :acking])
    field(:last_sent_at, :utc_datetime)
    timestamps()
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
  - `ack_delay`: Delay before sending an acknowledgment notification. Optional.
  - `state`: Current state of the reminder. Updated *before* the 'send' action is happened.
  - `last_sent_at`: When the reminder was last sent. Update *after* the 'send' action has happened and succeeded.
  """
  @type t :: %__MODULE__{
          id: any(),
          user_id: any(),
          text: String.t(),
          firing_time: Time.t(),
          firing_period: :daily | nil,
          firing_window: pos_integer() | nil,
          nagging_interval: pos_integer(),
          state: :pending | :scheduled | :nagging | :acking,
          last_sent_at: DateTime.t(),
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

  @doc ~S"""
  Calculates target firing `DateTime` based on the Reminder `:firing_time` and `:firing_period`.
  If the difference between resulting time is less than 10 seconds, the target date will be shifted to the next day.
  ### Examples
  iex> now = ~U[2025-05-04 20:00:00Z]
  ...> reminder = %RemindersCore.Data.Reminder {
  ...>  firing_time: ~T[21:00:00],
  ...>  firing_period: :daily
  ...> }
  ...> RemindersCore.Data.Reminder.get_target_time(reminder, now)
  ~U[2025-05-04 21:00:00Z]

  iex> now = ~U[2025-05-04 20:00:00Z]
  ...> reminder = %RemindersCore.Data.Reminder {
  ...>   firing_time: ~T[19:00:00],
  ...>   firing_period: :daily
  ...> }
  ...> RemindersCore.Data.Reminder.get_target_time(reminder, now)
  ~U[2025-05-05 19:00:00Z]
  """
  @spec get_target_time(t(), DateTime.t()) :: any()
  def get_target_time(reminder, now) do
    # todo: Add handling for firing_periods other than :daily
    target_datetime =
      now
      |> DateTime.to_date()
      |> DateTime.new!(reminder.firing_time)

    adjust_target_datetime(target_datetime, now)
  end
  
  def schedulable_states() do
    [:pending, :scheduled, :nagging, :acking]
  end

  defp adjust_target_datetime(target, now) do
    diff = DateTime.diff(target, now)

    if diff <= min_timespan_seconds() do
      target |> DateTime.add(1, :day)
    else
      target
    end
  end

  defp min_timespan_seconds, do: 10
end
