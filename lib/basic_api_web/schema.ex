defmodule BasicApiWeb.Schema do
  use Absinthe.Schema
  import Ecto.Query

  alias BasicApi.Models.{User, Camera}
  alias BasicApi.Repo

  import_types Absinthe.Type.Custom

  # Defina a consulta (Query)
  query do
    field :users, list_of(:user) do
      resolve &get_users_with_cameras/3
    end
  end

  # Defina o tipo de usuário (User)
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :enabled, :boolean
    field :disabled_at, :naive_datetime
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :cameras, list_of(:camera) do
      arg :filter_brand, :string
      arg :order_by_name, :string, default_value: "asc"
      resolve &get_cameras_for_user/3
    end
  end

  # Defina o tipo de câmera (Camera)
  object :camera do
    field :id, :id
    field :name, :string
    field :brand, :string
    field :enabled, :boolean
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  # Função para retornar os usuários e suas câmeras
  defp get_users_with_cameras(_, _, _) do
    query = from(u in User, preload: [:camera])

    users = Repo.all(query)
    {:ok, users}
  end

  defp get_cameras_for_user(%User{enabled: false} = _user, _, _), do: {:ok, []}

  defp get_cameras_for_user(user, %{filter_brand: brand, order_by_name: order_by_name}, _) do
    order_by = String.to_atom(order_by_name)

    query =
      Camera
      |> where([c], c.enabled == ^true and c.user_id == ^user.id)
      |> filter_by_brand(brand)
      |> order_by_name(order_by)

    cameras = Repo.all(query)
    {:ok, cameras}
  end

  defp filter_by_brand(query, nil), do: query
  defp filter_by_brand(query, brand), do: from(c in query, where: c.brand == ^brand)

  defp order_by_name(query, order_by), do: from(c in query, order_by: [{^order_by, c.name}])
end
