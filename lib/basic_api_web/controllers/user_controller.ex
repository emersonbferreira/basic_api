defmodule BasicApiWeb.UserController do
  use BasicApiWeb, :controller

  alias BasicApi.Models
  alias BasicApi.Models.User

  action_fallback BasicApiWeb.FallbackController

  def index(conn, _params) do
    users = Models.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Models.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Models.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Models.get_user!(id)

    with {:ok, %User{} = user} <- Models.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Models.get_user!(id)

    with {:ok, %User{}} <- Models.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
