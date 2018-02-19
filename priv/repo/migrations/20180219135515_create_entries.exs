defmodule ExLog.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :timestamp, :naive_datetime
      add :message, :string
      add :location, :string
      add :level_id, references(:levels, on_delete: :nothing)
      add :service_id, references(:services, on_delete: :nothing)

      timestamps()
    end

    create index(:entries, [:level_id])
    create index(:entries, [:service_id])
  end
end
