defmodule RemindersCore.Data.Reminder.Store do
  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset
  alias RemindersCore.Data.Repo
  alias RemindersCore.Data.Reminder
  @type reminder_id :: pos_integer()

  @spec create_reminder(Reminder.t()) :: {:ok, Reminder.t()} | {:error, any()}
  def create_reminder(%Reminder{} = reminder) do
    Repo.insert!(reminder)
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

  def get(user_id, states) do
    from(r in Reminder, where: r.state in ^states and r.user_id == ^user_id) |> Repo.all()
  end
  
  def set_scheduled(reminder_id) do
    set_state(reminder_id, :scheduled)
  end

  def set_nagging(reminder_id) do
    set_state(reminder_id, :nagging)
  end

  defp set_state(reminder_id, new_state) do
    get!(reminder_id) |> Changeset.change(%{state: new_state}) |> Repo.update!()
  end
end
