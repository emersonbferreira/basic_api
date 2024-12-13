defmodule BasicApi.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :name, :string
      add :brand, :string
      add :enabled, :boolean, default: true
      add :disabled_at, :naive_datetime
      add :user_id, references(:users)

      timestamps()
    end
  end
end
