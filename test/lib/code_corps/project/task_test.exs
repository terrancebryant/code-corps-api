defmodule CodeCorps.Project.TaskTest do
  use ExUnit.Case, async: true

  alias CodeCorps.Project.Task

  @base_attrs %{
    "title" => "Test task",
    "markdown" => "A test task",
    "status" => "open"
  }

  @invalid_attrs %{
    "title" => nil,
    "status" => "nonexistent"
  }

  describe "create/2" do
    test "creates task"
    test "returns errored changeset if attributes are invalid"
    test "if task is assigned a github repo, creates github issue on assigned repo"
    test "if github process fails, returns {:error, :github}"
  end
end
