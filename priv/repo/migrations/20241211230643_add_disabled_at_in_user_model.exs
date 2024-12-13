defmodule BasicApi.Repo.Migrations.AddDesabledAtInUserModel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :disabled_at, :naive_datetime
    end
  end
end
