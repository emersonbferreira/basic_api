defmodule BasicApi.Models.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.User

  schema "cameras" do
    field :enabled, :boolean, default: true
    field :name, :string
    field :brand, :string
    field :disabled_at, :naive_datetime

    timestamps()

    belongs_to :user, User
  end

  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:name, :brand, :enabled])
    |> validate_required([:name, :brand, :enabled])
    |> validate_inclusion(:brand, ["Intelbras", "Hikvision", "Giga", "Vivotek"])
  end
end
