defmodule BasicApiWeb.SessionController do
  use BasicApiWeb, :controller
  alias BasicApi.Auth.UserAuth

  def create(conn, %{"email" => email, "password" => password}) do
    case UserAuth.authenticate_user(email, password) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> json(%{token: token})

      :error ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Credenciais inválidas."})
    end
  end
end
