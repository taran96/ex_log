defmodule ExLogWeb.EntryController do
  use ExLogWeb, :controller

  alias ExLog.Logging
  alias ExLog.Logging.Entry

  action_fallback ExLogWeb.FallbackController

  def index(conn, _params) do
    entries = Logging.list_entries()
    render(conn, "index.json", entries: entries)
  end

  def create(conn, %{"entry" => entry_params}) do
    with {:ok, %Entry{} = entry} <- Logging.create_entry(entry_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", entry_path(conn, :show, entry))
      |> render("show.json", entry: entry)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Logging.get_entry!(id)
    render(conn, "show.json", entry: entry)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Logging.get_entry!(id)

    with {:ok, %Entry{} = entry} <- Logging.update_entry(entry, entry_params) do
      render(conn, "show.json", entry: entry)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Logging.get_entry!(id)
    with {:ok, %Entry{}} <- Logging.delete_entry(entry) do
      send_resp(conn, :no_content, "")
    end
  end
end
