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

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :enabled])
    |> validate_required([:name, :email, :password, :enabled])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> password_hash()
  end

  defp password_hash(%Ecto.Changeset{valid?: true, changes: %{"password" => password}} = changeset), do:
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

  defp password_hash(%Ecto.Changeset{valid?: true} = changeset), do: changeset
end
