defmodule CodeCorps.GitHub.IssueTest do
  use ExUnit.Case, async: true

  alias CodeCorps.GitHub.Issue

  describe "create/1" do
    test "calls github API to create an issue for assigned task, returns response"
    test "returns error response if there was trouble"
  end
end
