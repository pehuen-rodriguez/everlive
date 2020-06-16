defmodule EverliveWeb.PageController do
  use EverliveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
