defmodule RemindersCore.Data.Reminder.Store do
  alias Ecto.Changeset
  alias RemindersCore.Data.Reminder.ReminderState
  alias RemindersCore.Data.Repo
  alias RemindersCore.Data.Reminder
  @type reminder_id :: pos_integer()

  @spec insert!(Reminder.t()) :: {:ok, Reminder.t()} | {:error, any()}
  def insert!(%Reminder{} = reminder) do
    Repo.transaction(fn ->
      reminder_record = Repo.insert!(reminder)

      %ReminderState{
        state: :pending,
        reminder_id: reminder_record.id
      }
      |> Repo.insert!()

      reminder_record
    end)
  end

  @spec update!(RemindersCore.Data.Reminder.t()) :: {:ok, Reminder.t()} | {:error, any()}
  def update!(%Reminder{} = reminder) do
    reminder |> Reminder.changeset() |> Repo.update!()
  end

  @spec get!(reminder_id()) :: Reminder.t()
  def get!(id) do
    Repo.get!(Reminder, id)
  end

  def delete!(id) do
    reminder = Repo.get!(Reminder, id)
    Repo.delete!(reminder)
  end

  @spec get_all() :: [Reminder.t()]
  def get_all() do
    Repo.all(Reminder)
  end
  
  def get_state!(reminder_id) do
    Repo.get!(ReminderState, reminder_id)
  end

  def set_scheduled(reminder_id) do
    set_state(reminder_id, :scheduled)
  end

  def set_nagging(reminder_id) do
    set_state(reminder_id, :nagging)
  end

  defp set_state(reminder_id, new_state) do
    get_state!(reminder_id) |> Changeset.change(%{state: new_state}) |> Repo.update!()
  end
end
