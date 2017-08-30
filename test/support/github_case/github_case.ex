defmodule CodeCorps.GitHubCase do
  use ExUnit.CaseTemplate

  setup tags do
    case tags[:bypass] do
      nil -> :ok
      _ ->
        bypass = Bypass.open

        Application.put_env(:code_corps, :github_oauth_url, "http://localhost:#{bypass.port}")
        Application.put_env(:code_corps, :github_base_url, "http://localhost:#{bypass.port}/")

        on_exit fn ->
          Application.delete_env(:code_corps, :github_base_url)
          Application.delete_env(:code_corps, :github_oauth_url)
        end

        {:ok, bypass: bypass}
    end
  end

  using do
    quote do
      import CodeCorps.GitHubCase.Helpers
    end
  end
end
