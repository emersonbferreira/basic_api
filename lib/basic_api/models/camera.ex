defmodule BasicApi.Models.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.User

  schema "cameras" do
    field :enabled, :boolean, default: true
    field :name, :string
    field :brand, :string
    field :desabled_at, :utc_datetime, default: nil

    timestamps(type: :utc_datetime)

    belongs_to :users, User
  end

  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:name, :brand, :enabled])
    |> validate_required([:name, :brand, :enabled])
  end
end
