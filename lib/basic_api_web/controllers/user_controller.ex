defmodule BasicApiWeb.UserController do
  use BasicApiWeb, :controller

  alias BasicApi.Models
  alias BasicApi.Models.User
  alias BasicApi.Services.EmailSender

  action_fallback BasicApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Models.create_user(user_params) do
      conn
      |> put_status(:created)
      |> json(%{user: user})
    end
  end

  def create(conn, _), do: conn |> put_status(:bad_request) |> json(%{message: "Invalid request"})

  def notify_users(conn, _params) do
    with {:ok, _} <- EmailSender.notify_users() do
      conn
      |> put_status(:ok)
      |> json(%{message: "Users notified"})
    else
      _ -> conn |> put_status(:internal_server_error) |> json(%{message: "Internal server error"})
    end
  end
end
