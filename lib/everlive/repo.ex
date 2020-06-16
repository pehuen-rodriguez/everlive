defmodule Everlive.Repo do
  use Ecto.Repo,
    otp_app: :everlive,
    adapter: Ecto.Adapters.Postgres
end
