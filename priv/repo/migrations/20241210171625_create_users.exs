defmodule BasicApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :enabled, :boolean, default: true

      timestamps(type: :utc_datetime)
    end
  end

  create unique_index(:users, [:email])
end