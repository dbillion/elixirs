defmodule Newsfeed.KafkaConsumer do
  use GenServer
  require Logger
  alias NewsfeedWeb.FeedChannel

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.info("Starting custom Kafka Consumer for newsfeed topic")
    # We'll use the existing Kaffe setup for consuming messages
    {:ok, %{}}
  end
  
  # This function will be called by Kaffe when a message is received
  # It needs to be accessible by Kaffe's consumer group
  def handle_message(%{key: key, value: value, topic: "newsfeed"} = message) do
    Logger.info("Received Kafka message: #{inspect(message)}")
    # Forward the message to the Phoenix channel
    FeedChannel.broadcast_news(value)
    :ok
  end
  
  # Fallback for messages that don't match the pattern
  def handle_message(message) do
    Logger.warn("Received unexpected Kafka message format: #{inspect(message)}")
    :ok
  end
  
  # Add the missing handle_messages/1 function that Kaffe is trying to call
  # This function receives a list of messages and processes each one
  def handle_messages(messages) do
    Logger.info("Received batch of #{length(messages)} Kafka messages")
    
    Enum.each(messages, fn message ->
      handle_message(message)
    end)
    
    :ok
  end
end