defmodule ApiSandboxWeb.Router do
  use ApiSandboxWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApiSandboxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plugs.ApiKeyAuth
  end


  scope "/", ApiSandboxWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", ApiSandboxWeb do
    pipe_through :api
    get "/accounts", ApiController, :show_accounts
    get "/accounts/:account_id", ApiController, :show_account
    get "/accounts/:account_id/transactions", ApiController, :show_transactions
    get "/accounts/:account_id/transactions/:transaction_id", ApiController, :show_transaction
  end

  if Mix.env() == :dev do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ApiSandboxWeb.Telemetry
    end
  end
end
