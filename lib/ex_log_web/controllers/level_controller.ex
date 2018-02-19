defmodule ExLogWeb.LevelController do
  use ExLogWeb, :controller

  alias ExLog.Logging
  alias ExLog.Logging.Level

  action_fallback ExLogWeb.FallbackController

  def index(conn, _params) do
    levels = Logging.list_levels()
    render(conn, "index.json", levels: levels)
  end

  def create(conn, %{"level" => level_params}) do
    with {:ok, %Level{} = level} <- Logging.create_level(level_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", level_path(conn, :show, level))
      |> render("show.json", level: level)
    end
  end

  def show(conn, %{"id" => id}) do
    level = Logging.get_level!(id)
    render(conn, "show.json", level: level)
  end

  def update(conn, %{"id" => id, "level" => level_params}) do
    level = Logging.get_level!(id)

    with {:ok, %Level{} = level} <- Logging.update_level(level, level_params) do
      render(conn, "show.json", level: level)
    end
  end

  def delete(conn, %{"id" => id}) do
    level = Logging.get_level!(id)
    with {:ok, %Level{}} <- Logging.delete_level(level) do
      send_resp(conn, :no_content, "")
    end
  end
end
