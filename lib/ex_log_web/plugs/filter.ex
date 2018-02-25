defmodule ExLogWeb.Plugs.Filter do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, requested_filters) do
    filters = Map.take(conn.params, requested_filters)
    conn |> assign(:filters, filters)
  end
end
