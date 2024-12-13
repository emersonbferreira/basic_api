defmodule BasicApi.Models.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.User

  schema "cameras" do
    field :enabled, :boolean, default: true
    field :name, :string
    field :brand, :string

    timestamps()

    belongs_to :user, User
  end

  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:name, :brand, :enabled, :user_id])
    |> validate_required([:name, :brand, :enabled])
    |> validate_inclusion(:brand, ["Intelbras", "Hikvision", "Giga", "Vivotek"])
  end
end
