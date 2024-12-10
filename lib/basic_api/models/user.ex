defmodule BasicApi.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.Camera

  schema "users" do
    field :enabled, :boolean, default: false
    field :name, :string
    field :email, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime)

    has_many :camera, Camera
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :enabled])
    |> validate_required([:name, :email, :password_hash, :enabled])
  end
end
