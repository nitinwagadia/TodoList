defmodule Todo.List do

  defstruct [
    auto_id: 1 ,
    entries: %{}
  ]

  def new do
    %__MODULE__{}
  end

  def add_entry(todo_list, entry) do
    new_entry = Map.put(entry, :id , todo_list.auto_id)
    new_entries =  Map.put(todo_list.entries, todo_list.auto_id, new_entry)
    %__MODULE__{ todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def get_entry( todo_list, key) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.id == key end)
    |> Enum.map(fn { _, entry} -> entry end)
  end

  def update_entry(todo_list , %{task: task , date: date} ) do
    IO.puts("Update BOTH #{task} and #{date}")
    todo_list
  end

  def update_entry(todo_list , %{date: date} ) do
    IO.puts("Update DATE #{date}")
    todo_list
  end

  def update_entry(todo_list , %{id: id} ) do
    Map.fetch(todo_list.entries, id)
    %__MODULE__{ todo_list | auto_id: id*2 }
  end

end
