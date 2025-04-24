defmodule NewsfeedWeb.FeedChannel do
  use NewsfeedWeb, :channel
  require Logger

  def join("news:" <> id, _params, socket) do
    Logger.info("Client joined news:#{id} channel")
    {:ok, %{}, socket}
  end

  def handle_in(name, %{}, socket) do
    {:reply, {:ok, %{}}, socket}
  end

  # Method that can be called from other parts of the application
  # to broadcast messages to all subscribers of the news:latest channel
  def broadcast_news(message) do
    Logger.info("Broadcasting news: #{message}")
    NewsfeedWeb.Endpoint.broadcast("news:latest", "news:latest:new", %{news: message})
  end
end