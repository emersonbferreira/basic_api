defmodule BasicApiWeb.Plugs.RequireAuth do
  import Plug.Conn

  alias BasicApi.Auth.JWTToken

  @secret_key Application.compile_env(:joken, :default_signer)
  
  def init(default), do: default
  
  def call(conn, _opts) do
    signer = Joken.Signer.create("HS256", @secret_key)
    token = get_req_header(conn, "authorization")
            |> List.first()
            |> parse_token()

    case token && JWTToken.verify_and_validate(token, signer) do
      {:ok, _claims} -> conn
      _ -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end

  defp parse_token(nil), do: nil

  defp parse_token(token), do: String.replace(token, "Bearer ", "")
end
