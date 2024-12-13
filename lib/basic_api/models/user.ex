defmodule BasicApi.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BasicApi.Models.Camera

  @derive {Jason.Encoder, only: [:id, :name, :email, :enabled]}
  schema "users" do
    field :enabled, :boolean, default: true
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :disabled_at, :naive_datetime

    timestamps()

    has_many :camera, Camera
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> password_hash()
    |> set_disabled_at()
  end

  defp password_hash(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset), do:
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

  defp set_disabled_at(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp set_disabled_at(%Ecto.Changeset{valid?: true, changes: %{enabled: false}} = changeset) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)

    put_change(changeset, :disabled_at, time)
  end

  defp set_disabled_at(%Ecto.Changeset{valid?: true} = changeset), do: changeset
end
