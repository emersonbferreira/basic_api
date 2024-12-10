defmodule BasicApi.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :name, :string
      add :brand, :string
      add :enabled, :boolean, default: true
      add :desabled_at, :utc_datetime, default: nil
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end
