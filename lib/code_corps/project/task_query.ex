defmodule CodeCorps.Project.TaskQuery do
  import Ecto.Query

  alias CodeCorps.Helpers
  alias Ecto.Queryable

  @spec filter(Queryable.t, map) :: Queryable.t
  def filter(query, %{"filter" => %{} = params}), do: query |> filter(params |> IO.inspect)
  def filter(query, %{"project_id" => project_id} = params) do
    query
    |> where(project_id: ^project_id)
    |> filter(params |> Map.delete("project_id"))
  end
  def filter(query, %{"task_list_ids" => task_list_ids} = params) do
    task_list_ids = task_list_ids |> Helpers.String.coalesce_id_string
    query
    |> where([r], r.task_list_id in ^task_list_ids)
    |> filter(params |> Map.delete("task_list_ids"))
  end
  def filter(query, %{"status" => status} = params) do
    query
    |> where(status: ^status)
    |> filter(params |> Map.delete("status"))
  end
  def filter(query, %{}), do: query

  @spec query(Queryable.t, map) :: Queryable.t
  def query(query, %{"project_id" => project_id, "id" => number}) do
    query |> where(project_id: ^project_id, number: ^number)
  end
  def query(query, %{"task_list_id" => task_list_id, "id" => number}) do
    query |> where(task_list_id: ^task_list_id, number: ^number)
  end
  def query(query, %{"id" => id}) do
    query |> where(id: ^id)
  end
end
