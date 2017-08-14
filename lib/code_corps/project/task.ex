defmodule CodeCorps.Project.Task do
  @moduledoc """
  Handles special CRUD operations for `CodeCorps.Task`.
  """

  alias CodeCorps.{GitHub, Task, Repo}
  alias Ecto.{Changeset, Multi}

  @doc ~S"""
  Performs all actions involved in creating a task on a project
  """
  @spec create(map) :: {:ok, Task.t} | {:error, Changeset.t} | {:error, :github}
  def create(%{} = attributes) do
    multi =
      Multi.new
      |> Multi.insert(:task, attributes |> create_changeset)
      |> Multi.run(:github, (fn %{task: %Task{} = task} -> task |> connect_to_github end))

    case multi |> Repo.transaction do
      {:ok, %{task: %Task{} = task}} -> {:ok, task}
      {:error, :task, %Changeset{} = changeset, _steps} -> {:error, changeset}
      {:error, :github, _value, _steps} -> {:error, :github}
    end
  end

  @spec create_changeset(map) :: Changeset.t
  defp create_changeset(%{} = params) do
    %Task{}
    |> Task.changeset(params)
    |> Changeset.cast(params, [:project_id, :user_id, :github_repo_id])
    |> Changeset.validate_required([:project_id, :user_id])
    |> Changeset.assoc_constraint(:project)
    |> Changeset.assoc_constraint(:user)
    |> Changeset.assoc_constraint(:github_repo)
    |> Changeset.put_change(:status, "open")
  end

  @spec connect_to_github(Task.t) :: {:ok, Task.t | :not_connected} :: {:error, any}
  defp connect_to_github(%Task{github_repo_id: nil}), do: {:ok, :not_connected}
  defp connect_to_github(%Task{github_repo_id: _} = task) do
    with {:ok, issue} <- task |> Repo.preload(:github_repo, :user) |> GitHub.Issue.create() do
      task |> link_with_github_changeset(issue) |> Repo.update
    else
      {:error, tentacat_error} -> {:error, tentacat_error}
    end
  end

  @spec link_with_github_changeset(Task.t, map) :: Changeset.t
  defp link_with_github_changeset(%Task{} = task, %{"id" => github_issue_id}) do
    task |> Changeset.change(%{github_issue_id: github_issue_id})
  end
end
