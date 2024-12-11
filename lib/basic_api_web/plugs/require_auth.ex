defmodule BasicApiWeb.Plugs.RequireAuth do
  import Plug.Conn
  alias BasicApi.Auth.Guardian
  
  def init(default), do: default
  
  def call(conn, _opts) do
    token = get_req_header(conn, "authorization")
            |> List.first()
            |> String.replace("Bearer ", "")

    case Guardian.validate_token(token) do
      {:ok, _claims} -> conn
      :error -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
