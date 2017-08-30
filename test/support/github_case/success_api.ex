defmodule CodeCorps.GitHubCase.SuccessAPI do
  @moduledoc ~S"""
  A mocked github API layer which returns a default successful response for all
  github api requests.

  All tests in the test environment use this module as a mock for github api
  requests by default.

  If certain tests explicitly depend on the data returned by github, they can be
  mocked individually using the `CodeCorps.GitHubCase.Helpers.with_mock_api`
  macro.

  As support for new github endpoints is added, defaults for those endpoints
  should be added here.

  To assert a request has been made to github as a result as an action, the
  `assert_received` test helper can be used:

  ```
  assert_received({:get, "https://api.github.com/user", headers, body, options})
  ```
  """

  import CodeCorps.GitHubCase.Helpers

  def request(method, url, headers, body, options) do
    send(self(), {method, url, headers, body, options})

    {:ok, mock_response(method, url, headers, body, options)}
  end

  defp mock_response(:post, "https://github.com/login/oauth/access_token", _, _, _) do
    %{"access_token" => "foo_auth_token"}
  end
  defp mock_response(method, "https://api.github.com/" <> endpoint, headers, body, options) do
    mock_api_response(method, endpoint |> String.split("/"), headers, body, options)
  end
  defp mock_api_response(:get, ["user"], _, _, _) do
    %{
      "avatar_url" => "foo_url",
      "email" => "foo_email",
      "id" => 123,
      "login" => "foo_login"
    }
  end
  defp mock_api_response(_method, ["installation", "repositories"], _, _, _) do
    load_endpoint_fixture("installation_repositories")
  end
  defp mock_api_response(:post, ["installations", _id, "access_tokens"], _, _, _) do
    %{
      "token" => "v1.1f699f1069f60xxx",
      "expires_at" => Timex.now() |> Timex.shift(hours: 1) |> DateTime.to_iso8601
    }
  end
end
