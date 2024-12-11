defmodule BasicApi.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.Camera

  @derive {Jason.Encoder, only: [:id, :name, :email, :enabled]}
  schema "users" do
    field :enabled, :boolean, default: false
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :desabled_at, :utc_datetime

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
    |> set_desabled_at()
  end

  defp password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset), do:
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

  defp password_hash(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp set_desabled_at(%Ecto.Changeset{valid?: true, changes: %{enabled: false}} = changeset) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)

    put_change(changeset, :desabled_at, time)
  end

  defp set_desabled_at(%Ecto.Changeset{valid?: false} = changeset), do: changeset
end
