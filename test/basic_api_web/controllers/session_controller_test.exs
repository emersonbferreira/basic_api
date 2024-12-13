defmodule BasicApiWeb.SessionControllerTest do
    use BasicApiWeb.ConnCase

    import BasicApi.ModelsFixtures
  
    @login_attrs %{
      email: "some@email",
      password: "some password"
    }
    @invalid_attrs %{email: "invalid@email", password: "wrong password"}
  
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end
  
    describe "create user" do
      test "renders user when credentials is valid", %{conn: conn} do
        create_user()
        conn = post(conn, ~p"/users/login", @login_attrs)
  
        assert json_response(conn, 200)["token"]
      end
  
      test "renders errors when credentials is invalid", %{conn: conn} do
        conn = post(conn, ~p"/users/login", @invalid_attrs)
        assert json_response(conn, 401)["error"] == "Invalid Credentials."
      end
    end

    defp create_user() do
        user = user_fixture()
        %{user: user}
      end
  end
  