defmodule CodeCorps.GitHub.Issue do

  alias CodeCorps.{GithubRepo, Task, User}

  @spec create(Task.t) :: Tentacat.response
  def create(%Task{
    github_repo: %GithubRepo{github_account_login: github_owner, name: name},
    user: %User{github_auth_token: github_auth_token},
    markdown: markdown, title: title
    }) do

    # TODO: problem is, we can't mock this using bypass

    client = Tentacat.Client.new(%{access_token: github_auth_token})

    Tentacat.Issues.create(
      github_owner, name, %{"title" => title, "body" => markdown}, client
    )
  end
end
