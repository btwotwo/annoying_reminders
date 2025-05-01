defmodule StoreTest do
  use ExUnit.Case
  setup %{} do
    Testcontainers.PostgresContainer.new()
  end
end