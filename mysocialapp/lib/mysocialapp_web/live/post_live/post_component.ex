defmodule MysocialappWeb.PostLive.PostComponent do
  use MysocialappWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="post-#{@post.id}" class="post-card">
      <div class="post-header">
        <div class="post-avatar"></div>
        <div class="post-user">
          <div class="username">@<%= @post.username %></div>
          <div class="post-body"><%= @post.body %></div>
        </div>
      </div>
      <div class="post-actions">
        <div class="action-button">
          <button phx-click="like" phx-target={@myself} class="btn-icon">
            <i class="far fa-heart"></i>
          </button>
          <span class="action-count"><%= @post.likes_count %></span>
        </div>
        <div class="action-button">
          <button phx-click="repost" phx-target={@myself} class="btn-icon">
            <i class="fas fa-retweet"></i>
          </button>
          <span class="action-count"><%= @post.reposts_count %></span>
        </div>
        <div class="edit-controls">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id), class: "btn-icon edit" do %>
            <i class="far fa-edit"></i>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"], class: "btn-icon delete" do %>
            <i class="far fa-trash-alt"></i>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # def handle_event("like", _, socket) do
  #   post = socket.assigns.post
  #   # You would typically update the post in the database here
  #   updated_post = %{post | likes_count: post.likes_count + 1}

  #   {:noreply, assign(socket, post: updated_post)}
  # end

  # def handle_event("repost", _, socket) do
  #   post = socket.assigns.post
  #   # You would typically update the post in the database here
  #   updated_post = %{post | reposts_count: post.reposts_count + 1}

  #   {:noreply, assign(socket, post: updated_post)}
  # end
end
