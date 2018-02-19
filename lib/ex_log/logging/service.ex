defmodule ExLog.Logging.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExLog.Logging.Service


  schema "services" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Service{} = service, attrs) do
    service
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
