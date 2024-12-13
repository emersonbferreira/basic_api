defmodule BasicApiWeb.UserControllerTest do
  use BasicApiWeb.ConnCase

  import Mock

  alias BasicApi.Services.EmailSender
  alias BasicApi.Models.User
  alias BasicApi.Repo

  @create_attrs %{
    enabled: true,
    name: "some name",
    email: "some@email",
    password: "password"
  }
  @invalid_attrs %{enabled: nil, name: nil, email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @create_attrs)
      %User{id: user_id} = Repo.all(User) |> List.last()

      assert %{
         "id" => ^user_id,
         "email" => "some@email",
         "enabled" => true,
         "name" => "some name"
        } = json_response(conn, 201)["user"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "notify user" do
    setup_with_mocks([
      {BasicApi.Auth.JWTToken, [], [verify_and_validate: fn _token, _signer -> {:ok, "claims"} end]},
      {EmailSender, [], [notify_users: fn -> {:ok, nil} end]}
    ]) do
      :ok
    end

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "authorization", "token")}
    end

    test "POST /notify_users", %{conn: conn} do
      conn = post(conn, ~p"/notify_users")

      assert json_response(conn, 200)
      assert_called EmailSender.notify_users()
    end

    test "renders error", %{conn: conn} do
      with_mock EmailSender, [notify_users: fn -> {:error, "error"} end] do
        conn = post(conn, ~p"/notify_users")

        assert json_response(conn, 500)
        assert_called EmailSender.notify_users()
      end
    end
  end
end
