defmodule Todo.DatabaseWorker do
  use GenServer

  def init(db_folder) do
    {:ok, db_folder}
  end

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def handle_call({:get, list_key}, _ , db_folder) do
    file_content =  case File.read(file_path(db_folder, list_key)) do
                    {:ok, content } -> :erlang.binary_to_term(content)
                    _ -> nil
                   end
    {:reply, file_content, db_folder}
  end

  def handle_cast({:store , list_key , todo_list}, db_folder) do
    db_folder
    |> file_path(list_key)
    |> File.write!(:erlang.term_to_binary(todo_list))
    {:noreply, db_folder}
  end

  def store(worker_id, list_key , todo_list) do
    GenServer.cast(worker_id, {:store , list_key , todo_list})
  end

  def get(worker_id, list_key) do
    GenServer.call(worker_id, {:get, list_key})
  end

  defp file_path(db_folder , file_name) do
    Path.join(db_folder, to_string(file_name))
  end

end
