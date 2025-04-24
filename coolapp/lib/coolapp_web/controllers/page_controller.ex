defmodule CoolappWeb.PageController do
  use CoolappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
