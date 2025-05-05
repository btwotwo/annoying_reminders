defmodule RemindersCore.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias RemindersCore.Data.Repo

      import Ecto
      import Ecto.Query
      import RemindersCore.RepoCase
    end
  end

  setup tags do
    pid =
      Ecto.Adapters.SQL.Sandbox.start_owner!(RemindersCore.Data.Repo, shared: not tags[:async])

    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end
end
