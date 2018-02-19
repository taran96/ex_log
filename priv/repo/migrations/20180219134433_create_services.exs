defmodule ExLog.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string

      timestamps()
    end

    create unique_index(:services, [:name])
  end
end
