defmodule Newsfeed.Producer do
  @moduledoc """
  A module for producing messages to the Kafka topic.
  """

  @doc """
  Produces a message to the specified Kafka topic.
  
  ## Examples
  
      iex> Newsfeed.Producer.produce("newsfeed", "user_123", "New post from user_456")
      :ok
  
  """
  def produce(topic, key, value) do
    Kaffe.Producer.produce_sync(topic, [{key, value}])
  end

  @doc """
  Convenience function to produce a message to the newsfeed topic.
  
  ## Examples
  
      iex> Newsfeed.Producer.publish_to_newsfeed("user_123", "New post from user_456")
      :ok
  
  """
  def publish_to_newsfeed(key, value) do
    produce("newsfeed", key, value)
  end
end