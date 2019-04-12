defmodule Todo.Database do
  use GenServer

  @database_folder_name  "./database"

  def init(_) do
    File.mkdir_p!(@database_folder_name)
    {:ok, start_workers(@database_folder_name)}
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def handle_call({:get_worker, name}, _ , workerpool) do
    worker_id = :erlang.phash2(name, 3)
    worker = Map.get(workerpool, worker_id)
    {:reply, worker, workerpool}
  end

  def store(key, todo_list) do
    key
    |> get_worker()
    |> Todo.DatabaseWorker.store(key, todo_list)
  end

  def get(key) do
    key
    |> get_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp get_worker(list_name) do
    GenServer.call(__MODULE__, {:get_worker, list_name})
  end

  def start_workers(db_folder) do
    Enum.reduce(0..2, %{}, fn index , worker_list ->
                                       {:ok , pid} = Todo.DatabaseWorker.start(db_folder)
                                       Map.put(worker_list, index, pid)  end)
  end

end
