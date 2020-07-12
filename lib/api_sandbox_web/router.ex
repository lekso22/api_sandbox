defmodule ApiSandboxWeb.Router do
  use ApiSandboxWeb, :router

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

    live "/", PageLive, :index
  end

  scope "/api", ApiSandboxWeb do
    pipe_through :api
    get "/accounts", ApiController, :index
    get "/accounts/:account_id", ApiController, :show
    get "/accounts/:account_id/transactions", ApiController, :show_transactions
  end
end
