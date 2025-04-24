defmodule MysocialappWeb.PageController do
  use MysocialappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
