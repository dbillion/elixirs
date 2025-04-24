defmodule GreatAppWeb.PageController do
  use GreatAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
