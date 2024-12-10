defmodule BasicApi.Models.Camera do
  use Ecto.Schema
  import Ecto.Changeset
    
  alias BasicApi.Models.User

  schema "camera" do
    field :name, :string
    field :brand, :string
    field :enabled, :bool
    field :desabled_at, :timestamp, default: nil
    
    timestamps()

    belongs_to :users, User
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :brand, :enabled])
  end
end