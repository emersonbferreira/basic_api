defmodule BasicApiWeb.SchemaControllerTest do
  use BasicApiWeb.ConnCase, async: true

  import BasicApi.ModelsFixtures
  import Mock

  setup_with_mocks([
    {BasicApi.Auth.JWTToken, [], [verify_and_validate: fn _token, _signer -> {:ok, "claims"} end]}
  ]) do

    :ok
  end

  describe "GET /cameras" do
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "authorization", "token")}
    end

    test "returns users and their cameras", %{conn: conn} do
      user = user_fixture()
      camera_fixture(user, %{})

      query = """
      query {
        users {
          id
          name
          email
          cameras {
            id
            name
            brand
            enabled
          }
        }
      }
      """

      query_param = URI.encode_www_form(query)
      response = conn
                 |> get("/cameras?query=#{query_param}")
                 |> json_response(200)

      assert %{
               "data" => %{
                 "users" => [
                   %{
                     "id" => _id,
                     "name" => "some name",
                     "email" => "some@email",
                     "cameras" => [
                       %{
                         "id" => _camera_id,
                         "name" => "some camera",
                         "brand" => "Hikvision",
                         "enabled" => true
                       }
                     ]
                   }
                 ]
               }
             } = response
    end

    test "filters cameras by brand", %{conn: conn} do
      user = user_fixture()
      camera_fixture(user, %{brand: "Hikvision"})
      camera_fixture(user, %{brand: "Intelbras"})

      query = """
      query {
        users {
          id
          name
          cameras(filterBrand: "Intelbras") {
            id
            name
            brand
            enabled
          }
        }
      }
      """
      query_param = URI.encode_www_form(query)
      response = conn
                 |> get("/cameras?query=#{query_param}")
                 |> json_response(200)

      assert %{
               "data" => %{
                 "users" => [
                   %{
                     "id" => _id,
                     "name" => "some name",
                     "cameras" => [
                       %{
                         "brand" => "Intelbras"
                       }
                     ]
                   }
                 ]
               }
             } = response
    end

    test "orders cameras by name", %{conn: conn} do
      user = user_fixture()
      camera_fixture(user, %{name: "Camera A"})
      camera_fixture(user, %{name: "Camera B"})

      query = """
      query {
        users {
          id
          name
          cameras(orderByName: "asc") {
            id
            name
          }
        }
      }
      """
      query_param = URI.encode_www_form(query)
      response = conn
                 |> get("/cameras?query=#{query_param}")
                 |> json_response(200)

      assert %{
               "data" => %{
                 "users" => [
                   %{
                     "id" => _id,
                     "name" => "some name",
                     "cameras" => [
                       %{"name" => "Camera A"},
                       %{"name" => "Camera B"}
                     ]
                   }
                 ]
               }
             } = response
    end

    test "returns empty cameras if user is disabled", %{conn: conn} do
      user_fixture(%{enabled: false}).id

      query = """
      query {
        users {
          id
          name
          cameras {
            id
            name
            enabled
          }
        }
      }
      """
      query_param = URI.encode_www_form(query)
      response = conn
                 |> get("/cameras?query=#{query_param}")
                 |> json_response(200)

      assert %{
               "data" => %{
                 "users" => [
                   %{
                     "id" => _id,
                     "name" => "some name",
                     "cameras" => []
                   }
                 ]
               }
             } = response
    end
  end
end
