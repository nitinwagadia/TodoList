defmodule Todo.Server do
  use GenServer

  def init(name) do
    {:ok, { name, Todo.Database.get(name) || Todo.List.new}}
  end

  def start(list_name) do
    GenServer.start(__MODULE__, list_name)
  end

  def put(pid, entry) do
    GenServer.cast(pid, {:add, entry } )
  end

  def get_all(pid) do
    GenServer.call(pid, {:get_all} )
  end

  def get(pid, key) do
    GenServer.call(pid, {:get , key})
  end

  def info(pid) do
    send(pid, {"whatever"})
  end

  def handle_call({:get_all}, _ ,  { name , current_state}) do
       {:reply, current_state, { name , current_state}}
  end

  def handle_call({:get, key}, _ ,  {name , current_state}) do
    {:reply, Todo.List.get_entry(current_state, key), {name , current_state}}
  end

  def handle_cast({:add , entry }, {name , current_state}) do
    new_list = Todo.List.add_entry(current_state, entry)
    Todo.Database.store(name, new_list)
    {:noreply , {name , new_list} }
  end

  def handle_cast({:update, update_entry}, { name , current_state}) do
      IO.inspect(update_entry)
      new_list = Todo.List.update_entry(current_state, update_entry )
      Todo.Database.store(name, new_list)
      {:noreply , {name , new_list} }
  end

end
