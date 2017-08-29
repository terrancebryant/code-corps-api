defmodule CodeCorpsWeb.TaskController do
  use CodeCorpsWeb, :controller
  use JaResource

  import CodeCorps.Helpers.Query, only: [
    project_filter: 2, project_id_with_number_filter: 2, task_list_id_with_number_filter: 2,
    sort_by_order: 1, task_list_filter: 2, task_status_filter: 2
  ]

  alias CodeCorps.{Task, Project}

  plug :load_and_authorize_changeset, model: Task, only: [:create]
  plug :load_and_authorize_resource, model: Task, only: [:update]
  plug JaResource

  @spec model :: module
  def model, do: CodeCorps.Task

  def handle_index(conn, params) do
    tasks =
      Task
      |> project_filter(params)
      |> task_list_filter(params)
      |> task_status_filter(params)
      |> sort_by_order
      |> Repo.all

    conn
    |> render("index.json-api", data: tasks)
  end

  @spec record(Plug.Conn.t, String.t) :: Task.t | nil
  def record(%Plug.Conn{params: %{"project_id" => _project_id} = params}, _number_as_id) do
    Task
    |> project_id_with_number_filter(params)
    |> Repo.one
  end
  def record(%Plug.Conn{params: %{"task_list_id" => _task_list_id} = params}, _number_as_id) do
    Task
    |> task_list_id_with_number_filter(params)
    |> Repo.one
  end
  def record(_conn, id), do: Task |> Repo.get(id)

  @spec handle_create(Plug.Conn.t, map) :: {:ok, Task.t} | {:error, Ecto.Changeset.t} | {:error, :github}
  def handle_create(%Plug.Conn{} = _conn, %{} = attributes) do
    attributes |> Project.Task.create
  end

  @spec handle_update(Plug.Conn.t, Task.t, map) :: Ecto.Changeset.t
  def handle_update(_conn, task, attributes) do
    task |> Project.Task.update(attributes)
  end
end
