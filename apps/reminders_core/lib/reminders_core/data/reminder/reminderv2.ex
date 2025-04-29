defmodule RemindersCore.Data.Reminder.Reminderv2 do
  use Ecto.Schema

  schema "reminders" do
    field(:text, :string)
    field(:firing_time, :time)
    field(:firing_period, Ecto.Enum, values: [:daily])
    field(:firing_window, :integer)
    field(:nagging_interval, :integer)
    has_one(:state, RemindersCore.Data.Reminder.ReminderState)
  end

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
