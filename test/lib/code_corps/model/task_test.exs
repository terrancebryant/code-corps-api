defmodule CodeCorps.TaskTest do
  use CodeCorps.ModelCase

  alias CodeCorps.Task

  @valid_attrs %{
    title: "Test task",
    markdown: "A test task"
  }
  @invalid_attrs %{}

  describe "create/2" do
    test "is invalid with invalid attributes" do
      changeset = Task.changeset(%Task{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "renders body html from markdown" do
      user = insert(:user)
      project = insert(:project)
      task_list = insert(:task_list)
      changes = Map.merge(@valid_attrs, %{
        markdown: "A **strong** body",
        project_id: project.id,
        task_list_id: task_list.id,
        user_id: user.id
      })
      changeset = Task.changeset(%Task{}, changes)
      assert changeset.valid?
      assert changeset |> get_change(:body) == "<p>A <strong>strong</strong> body</p>\n"
    end
  end

  describe "update_changeset/2" do
    test "only allows specific values for status" do
      changes = Map.put(@valid_attrs, :status, "nonexistent")
      changeset = Task.update_changeset(%Task{}, changes)
      refute changeset.valid?
    end
  end

  describe "github_changeset/2" do
    test "casts github_id attribute" do
      changes = %{"github_id" => 1, "fake_attribute" => "foo"}
      changeset = Task.github_changeset(%Task{}, changes)
      assert changeset.changes |> Map.has_key?(:github_id)
      refute changeset.changes |> Map.has_key?(:fake_attribute)
    end

    test "validates github_id attribute is included" do
      changes = %{"fake_attribute" => "foo"}
      changeset = Task.github_changeset(%Task{}, changes)
      refute changeset.valid?
    end
  end
end
