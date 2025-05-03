defmodule StoreTest do
  use RemindersCore.RepoCase
  use ExUnitProperties
  alias RemindersCore.Data.Reminder.ReminderState
  alias RemindersCore.Data.Reminder

  
  property "when inserting new reminder, also creates a state record" do
    check all(reminder <- RemindersCore.Factory.reminder_generator()) do
      Repo.delete_all(Reminder)
      Repo.delete_all(ReminderState)

      {:ok, reminder_record} = Reminder.Store.insert!(reminder)

      state = Repo.get_by(ReminderState, reminder_id: reminder_record.id)
      assert state != nil
    end
  end
end
