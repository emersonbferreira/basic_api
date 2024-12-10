defmodule BasicApi.Repo.Migrations.AddCameraTable do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :name, :string
      add :brand, :string
      add :enabled, :bool
      add :desabled_at, :timestamp, default: nil
      add :user_id, references(:users)

      timestamps()
  end
end
