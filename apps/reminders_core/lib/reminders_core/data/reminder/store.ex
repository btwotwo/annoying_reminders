defmodule RemindersCore.Data.Reminder.Store do
  alias RemindersCore.Data.Reminder
  use GenServer
  
  @type reminder_id :: any()
  
  @impl true
  def init(_opts) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:upsert, %Reminder{id: id} = reminder}, _from, state) do
    action = if(Map.has_key?(state, id), do: :updated, else: :created)
    {:reply, {:ok, action, id}, Map.put(state, id, reminder)}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    case Map.get(state, id) do
      nil -> {:reply, {:error, :not_found}, state}
      val -> {:reply, {:ok, val}, state}
    end
  end

  @impl true
  def handle_call({:delete, id}, _from, state) do
    case Map.pop(state, id) do
      {nil, _} -> {:reply, {:error, :not_found}, state}
      {_val, deleted} -> {:reply, {:ok, id}, deleted}
    end

    {:reply, {:ok}, Map.delete(state, id)}
  end

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec upsert(Reminder.t()) :: {:ok, :updated | :created, reminder_id()}
  def upsert(%Reminder{} = reminder) do
    GenServer.call(__MODULE__, {:upsert, reminder})
  end

  @spec get(reminder_id()) :: {:ok, Reminder.t()} | {:error, any()}
  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  @spec delete(reminder_id()) :: {:ok} | {:error, :not_found}
  def delete(id) do
    GenServer.call(__MODULE__, {:delete, id})
  end
end