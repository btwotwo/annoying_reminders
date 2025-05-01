ExUnit.start()
Testcontainers.start_link()
Ecto.Adapters.SQL.Sandbox.mode(RemindersCore.Data.Repo, :manual)