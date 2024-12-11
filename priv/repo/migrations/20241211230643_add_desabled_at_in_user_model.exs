defmodule BasicApi.Repo.Migrations.AddDesabledAtInUserModel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :desabled_at, :utc_datetime
    end
  end
end
