defmodule GreatAppWeb.PageController do
  use GreatAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def hello(conn, _params) do
    html(conn, "hello , worlds")
  end

  # def goodbye(conn, _params) do
  #   render(conn, "goodbye.html")
  # end
end
