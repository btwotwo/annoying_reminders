defmodule RemindersCore.Data.User do
  @enforce_keys [:id]
  defstruct [:id]

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end
end
