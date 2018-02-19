defmodule ExLogWeb.PageController do
  use ExLogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
