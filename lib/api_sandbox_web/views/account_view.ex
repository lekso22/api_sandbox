defmodule ApiSandboxWeb.AccountView do
  use ApiSandboxWeb, :view

  def render("index.json", assigns) do
    assigns.data
    |> Enum.map(&as_json/1)
  end

  def as_json(data) do
    %{
      color: data.color,
      value: data.value
    }
  end
end