defmodule Todo.Cache do
  use GenServer

  def init(_) do
    Todo.Database.start
    {:ok, %{}}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def get_process(cache_pid, key) do
    GenServer.call(cache_pid, {:get_list, key})
  end

  def handle_call( request , _ , todo_servers ) do

    case request do
      {:get_list, key} ->
              case Map.fetch(todo_servers, key) do
                 {:ok , server} ->
                              {:reply , server, todo_servers}
                 :error  ->
                       {:ok, new_server} = Todo.Server.start(key)
                         {:reply, new_server, Map.put(todo_servers, key, new_server)}
              end
    end
  end

end
