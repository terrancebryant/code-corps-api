defmodule CodeCorps.GitHub.Issue do

  alias CodeCorps.{Task, Repo}

  require Logger

  def create_issue(task, current_user, github_owner, github_repo) do
    access_token = current_user.github_access_token || default_user_token() # need to create the GitHub user for this token
    client = Tentacat.Client.new(%{access_token: access_token})
    request_result = Tentacat.Issues.create(
      github_owner,
      github_repo,
      Map.take(task, [:title, :body]),
      client
    )
    case request_result do
      {:ok, response} ->
        github_id = response.body["id"] |> String.to_integer()

        task
        |> Task.github_changeset(%{"github_id" => github_id})
        |> Repo.update()
      {:error, error} ->
        Logger.error "Could not create issue for Task ID: #{task.id}. Error: #{error}"
        {:ok, task}
    end
  end

  defp default_user_token do
    System.get_env("GITHUB_DEFAULT_USER_TOKEN")
  end
end
