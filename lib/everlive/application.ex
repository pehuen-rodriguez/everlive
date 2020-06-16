defmodule Everlive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Everlive.Repo,
      # Start the Telemetry supervisor
      EverliveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Everlive.PubSub},
      # Start the Endpoint (http/https)
      EverliveWeb.Endpoint,
      # Start a worker by calling: Everlive.Worker.start_link(arg)
      # {Everlive.Worker, arg}
      EverliveWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Everlive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EverliveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
