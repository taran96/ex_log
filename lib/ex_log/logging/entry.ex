defmodule ExLog.Logging.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExLog.Logging.Entry


  schema "entries" do
    field :location, :string
    field :message, :string
    field :timestamp, :naive_datetime
    field :level_id, :id
    field :service_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:timestamp, :message, :location])
    |> validate_required([:timestamp, :message, :location])
  end
end
