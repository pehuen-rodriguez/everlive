defmodule EverliveWeb.RoomChannel do
  use EverliveWeb, :channel
  alias EverliveWeb.Presence

  defp topic(room_id), do: "room:#{room_id}"

  def join(
        "room:" <> room_id,
        _params,
        socket = %Phoenix.Socket{assigns: %{user_id: user_id, username: username}}
      ) do
    # params(%{"token" => "roomToken"})

    send(
      self(),
      {:after_join,
       %{
         topic: topic(room_id),
         user_id: user_id,
         username: username
       }}
    )

    {:ok, %{userId: user_id}, assign(socket, :room_id, room_id)}
  end

  def handle_info({:after_join, %{topic: topic, user_id: user_id, username: username}}, socket) do
    # params %{topic: "room:123", user_id: "1"}
    # socket %Phoenix.Socket{
    #   assigns: %{room_id: "123", user_id: "Alfonso Allen"},
    #   channel: EverliveWeb.RoomChannel,
    #   channel_pid: #PID<0.532.0>,
    #   endpoint: EverliveWeb.Endpoint,
    #   handler: EverliveWeb.UserSocket,
    #   id: "users_socket:Alfonso Allen",
    #   join_ref: "3",
    #   joined: true,
    #   private: %{log_handle_in: :debug, log_join: :info},
    #   pubsub_server: Everlive.PubSub,
    #   ref: nil,
    #   serializer: Phoenix.Socket.V2.JSONSerializer,
    #   topic: "room:123",
    #   transport: :websocket,
    #   transport_pid: #PID<0.521.0>
    # }

    Presence.track_presence(
      self(),
      topic,
      user_id,
      default_user_presence_payload(user_id, username)
    )

    push(socket, "presence_state", Presence.list_presences(topic))

    {:noreply, socket}
  end

  # def handle_in(
  #       "new_message",
  #       params,
  #       socket = %Phoenix.Socket{assigns: %{user_id: user_id, room_id: room_id}}
  #     ) do
  #   Presence.update_presence(
  #     self(),
  #     topic(socket.assigns.room_id),
  #     socket.assigns.user_id,
  #     payload
  #   )

  #   user = socket.assigns.user_id

  #   broadcast!(socket, "new_message", %{
  #     id: params.id,
  #     user: user,
  #     body: params.body,
  #     at: params.at
  #   })

  #   {:reply, :ok, socket}
  # end

  def handle_in(
        "move",
        %{
          "posX" => pos_x,
          "posY" => pos_y,
          "posZ" => pos_z,
          "rotX" => rot_x,
          "rotY" => rot_y,
          "rotZ" => rot_z
        },
        socket = %Phoenix.Socket{assigns: %{user_id: user_id, room_id: room_id}}
      ) do
    Presence.update_presence(
      self(),
      topic(room_id),
      user_id,
      %{pos_x: pos_x, pos_y: pos_y, pos_z: pos_z, rot_x: rot_x, rot_y: rot_y, rot_z: rot_z}
    )

    {:reply, :ok, socket}
  end

  defp default_user_presence_payload(user_id, username) do
    %{
      typing: false,
      user_id: user_id,
      username: username,
      pos_x: 0,
      pos_y: 1.75,
      pos_z: 0,
      rot_x: 0,
      rot_y: 0,
      rot_z: 0,
      online_at: inspect(System.system_time(:second))
    }
  end
end
