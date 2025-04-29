defmodule RemindersCore.Data.User.Store do
  alias RemindersCore.Data.User
  use GenServer

  @type user_id :: any()

  @impl true
  def init(_opts) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:upsert, %User{id: id} = user}, _from, state) do
    action = if(Map.has_key?(state, id), do: :updated, else: :created)
    {:reply, {:ok, action, id}, Map.put(state, id, user)}
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
      {nil, new_state} -> {:reply, {:error, :not_found}, new_state}
      {_val, new_state} -> {:reply, {:ok, id}, new_state}
    end
  end

  @impl true
  def handle_call({:get_all}, _from, state) do
    vals = Map.to_list(state) |> Enum.map(fn {key, value} -> value end)
    {:reply, {:ok, vals}, state}
  end

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def upsert(%User{} = user) do
    GenServer.call(__MODULE__, {:upsert, user})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def delete(id) do
    GenServer.call(__MODULE__, {:delete, id})
  end

  def get_all() do
    GenServer.call(__MODULE__, {:get_all})
  end
end
