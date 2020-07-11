defmodule ApiSandboxWeb.AccountController do
  use ApiSandboxWeb, :controller

  def index(conn, _params) do
   data = [
      %{
        color: "yellow",
        value: "#ff0"
      },
      %{
        color: "black",
        value: "#000"
      }
    ]
    render(conn, data: data)
  end
end