defmodule ExLogWeb.LevelView do
  use ExLogWeb, :view
  alias ExLogWeb.LevelView

  def render("index.json", %{levels: levels}) do
    %{data: render_many(levels, LevelView, "level.json")}
  end

  def render("show.json", %{level: level}) do
    %{data: render_one(level, LevelView, "level.json")}
  end

  def render("level.json", %{level: level}) do
    %{id: level.id,
      name: level.name,
      priority: level.priority}
  end
end
