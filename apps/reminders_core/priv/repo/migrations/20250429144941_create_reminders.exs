defmodule RemindersCore.Data.Reminder.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :text, :string, null: false
      add :firing_time, :time, null: false
      add :firing_period, :string, null: false
      add :firing_window, :integer, null: true
      add :nagging_interval, :integer, null: true
      timestamps()
    end

    create table(:reminder_states, primary_key: false) do
      add :reminder_id,
          references(:reminders, on_delete: :delete_all),
          primary_key: true,
          null: false
      add :state, :integer, null: false
      timestamps()
    end
  end
end
