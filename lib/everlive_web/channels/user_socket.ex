defmodule EverliveWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", EverliveWeb.RoomChannel

  @impl true
  def connect(%{"username" => username}, socket, _connect_info) do
    # user_id "Jamar Dewinne"
    # connect_info %{}
    {:ok, assign(socket, username: username, user_id: UUID.uuid4())}
  end

  @impl true
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
