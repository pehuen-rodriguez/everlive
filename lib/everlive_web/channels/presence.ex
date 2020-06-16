defmodule EverliveWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](http://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :everlive,
    pubsub_server: Everlive.PubSub

  alias EverliveWeb.Presence

  def track_presence(pid, topic, key, payload) do
    Presence.track(pid, topic, key, payload)
  end

  def update_presence(pid, topic, key, payload) do
    metas =
      Presence.get_by_key(topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(pid, topic, key, metas)
  end

  def list_presences(topic) do
    # presence %{
    #   "1" => %{
    #     metas: [
    #       %{
    #         online_at: "1592263182",
    #         phx_ref: "Fhja7ZynJ5h3ywUE",
    #         typing: false,
    #         user_id: "1"
    #       },
    #       %{
    #         online_at: "1592263288",
    #         phx_ref: "FhjbBjkK46B3ywHC",
    #         typing: false,
    #         user_id: "1"
    #       }
    #     ]
    #   }
    # }
    Presence.list(topic)
  end
end
