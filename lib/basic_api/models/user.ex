defmodule BasicApi.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.Camera

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :enabled, :bool

    timestamps()

    has_many :camera, Camera
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :enabled])
  end
end
