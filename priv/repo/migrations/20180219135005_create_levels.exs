defmodule ExLog.Repo.Migrations.CreateLevels do
  use Ecto.Migration

  def change do
    create table(:levels) do
      add :name, :string
      add :priority, :integer

      timestamps()
    end

    create unique_index(:levels, [:name])
  end
end
