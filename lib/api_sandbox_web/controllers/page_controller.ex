defmodule ApiSandboxWeb.PageController do
  use ApiSandboxWeb, :controller

  def index(conn, _params) do
    if Mix.env() in [:dev, :test] do
      redirect(conn, to: "/dashboard/nonode%40nohost/metrics?group=vm")
    else
      render(conn, "index.html")
    end
  end
end
