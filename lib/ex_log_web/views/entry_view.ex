defmodule ExLogWeb.EntryView do
  use ExLogWeb, :view
  alias ExLogWeb.EntryView

  def render("index.json", %{entries: entries}) do
    %{data: render_many(entries, EntryView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, EntryView, "entry.json")}
  end

  def render("entry.json", %{entry: entry}) do
    %{id: entry.id,
      timestamp: entry.timestamp,
      message: entry.message,
      location: entry.location}
  end
end
