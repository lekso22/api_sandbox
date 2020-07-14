defmodule Plugs.ApiKeyAuthTest do
  use ExUnit.Case
  use Plug.Test

  alias Plugs.ApiKeyAuth

  test "Error: API key is not provided" do
    instance = ApiKeyAuth.init([])

    conn =
      conn(:get, "api/accounts", "")

    response = ApiKeyAuth.call(conn, instance)
    assert response.halted
    assert response.resp_body == "Missing API key"
  end

  test "Error: Basic auth is not provided" do
    instance = ApiKeyAuth.init([])

    conn =
      conn(:get, "api/accounts", "")
      |> put_req_header("authorization", "Bearer dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")

    response = ApiKeyAuth.call(conn, instance)

    assert response.halted
    assert response.resp_body == "Wrong authentication attempt"
  end

  test "Provided with the correct API key generates accounts" do
    instance = ApiKeyAuth.init([])
    conn =
      conn(:get, "api/accounts", "")
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")

    returned_conn = ApiKeyAuth.call(conn, instance)
    accounts = returned_conn.assigns[:accounts]

    assert Map.has_key?(returned_conn.assigns, :accounts) # accounts stored in conn
    assert length(accounts) > 0
  end

  test "parse_header extracts auth token" do
     api_key = ApiKeyAuth.parse_header("Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
     assert api_key == "test_BDDBfBLQQGHc_gWasd:"
  end
end
