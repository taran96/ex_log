defmodule ExLog.Logging.Level do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExLog.Logging.Level


  schema "levels" do
    field :name, :string
    field :priority, :integer

    timestamps()
  end

  @doc false
  def changeset(%Level{} = level, attrs) do
    level
    |> cast(attrs, [:name, :priority])
    |> validate_required([:name, :priority])
    |> unique_constraint(:name)
  end
end
