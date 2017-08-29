defmodule CodeCorps.GitHub.IssueTest do
  use CodeCorps.{
    ModelCase,
    GitHubCase
  }

  import CodeCorps.TestHelpers.GitHub

  alias CodeCorps.GitHub.Issue

  @create_issue load_endpoint_fixture("create_issue")

  describe "create/1" do
    @tag bypass: %{
      "/repos/foo/bar/issues" => {201, @create_issue}
    }
    test "calls github API to create an issue for assigned task, returns response" do
      github_repo = insert(:github_repo, github_account_login: "foo", name: "bar")
      user = insert(:user, github_auth_token: "baz")
      task = insert(:task, github_repo: github_repo, user: user)

      Issue.create(task) |> IO.inspect
    end

    test "returns error response if there was trouble"
  end
end
