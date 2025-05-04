defmodule StoreTest do
  use RemindersCore.RepoCase
  use ExUnitProperties
  alias RemindersCore.Data.Reminder.ReminderState
  alias RemindersCore.Data.Reminder
  alias RemindersCore.Data.User
  
  setup do
    user = %User{}
    user_record = Repo.insert!(user)

    %{user_id: user_record.id}
  end

  property "when inserting new reminder, also creates a state record with :pending state", context do
    check all(reminder <- RemindersCore.Factory.reminder_generator(context[:user_id])) do
      Repo.delete_all(Reminder)
      Repo.delete_all(ReminderState)

      {:ok, reminder_record} = Reminder.Store.create_reminder(reminder)

      state = Repo.get_by(ReminderState, reminder_id: reminder_record.id)
      assert state != nil
      assert state.state == :pending
    end
  end
end
