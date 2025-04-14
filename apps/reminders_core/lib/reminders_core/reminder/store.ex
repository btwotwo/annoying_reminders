defmodule RemindersCore.Reminder.Store do
  use GenServer

  defstruct map: Map.new()

  def init(:ok) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:insert, %RemindersCore.Reminder{} = reminder}, _from, state) do
    {:reply, :ok, Map.put(state, {reminder.user_id, reminder.id}, reminder)}
  end

  # client code
  def create(%RemindersCore.Reminder{} = reminder) do
    GenServer.call(__MODULE__, {:insert, reminder})
  end
  
end
