defmodule BasicApiWeb.SchemaTest do
  use BasicApiWeb.ConnCase, async: true

  import BasicApi.ModelsFixtures
  
  describe "users query" do
    test "returns users and their cameras" do
      user = user_fixture()
      camera_fixture(user)

      query = """
      query {
        users {
          name
          email
          cameras {
            name
            brand
            enabled
          }
        }
      }
      """

      # Executa a query no seu schema Absinthe
      response = Absinthe.run(query, BasicApiWeb.Schema)

      assert {:ok, 
              %{data:
                %{"users" => [%{
                    "name" => "some name",
                    "email" => "some@email",
                    "cameras" => [%{
                      "name" => "some camera",
                      "brand" => "Hikvision",
                      "enabled" => true
                    }]
                  }]
                }
              }} = response
    end
  end
  
  describe "filter cameras by brand" do
    test "filters cameras by brand" do
      user = user_fixture()
      camera_fixture(user, brand: "Hikvision")
      camera_fixture(user, brand: "Intelbras")

      query = """
      query {
        users {
          id
          name
          cameras(filterBrand: "Hikvision") {
            id
            name
            brand
            enabled
          }
        }
      }
      """

      response = Absinthe.run(query, BasicApiWeb.Schema)

      assert {:ok, %{data: %{"users" => [%{"id" => _id, "name" => "some name", "cameras" => [%{"brand" => "Hikvision"}]}]}}} = response
    end
  end

  describe "order cameras by name" do
    test "orders cameras by name" do
      user = user_fixture()
      camera_fixture(user, name: "Camera A")
      camera_fixture(user, name: "Camera B")

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

      response = Absinthe.run(query, BasicApiWeb.Schema)

      assert {:ok,
                %{data:
                  %{"users" => [%{
                    "id" => _id,
                    "name" => "some name",
                    "cameras" =>[%{
                        "name" => "Camera A"
                      }, 
                      %{
                        "name" => "Camera B"
                      }]
                    }]
                  }
                }
              } = response
    end
  end
  
  describe "get users with cameras" do
    test "returns users with cameras if they have enabled cameras" do
      user = user_fixture(enabled: true)
      camera_fixture(user, enabled: true)

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

      response = Absinthe.run(query, BasicApiWeb.Schema)

      assert {:ok, %{data: %{"users" => [%{"id" => _id, "name" => "some name", "cameras" => [%{"enabled" => true}]}]}}} = response
    end

    test "returns empty cameras if user is disabled" do
      user_fixture(enabled: false)

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

      response = Absinthe.run(query, BasicApiWeb.Schema)

      assert {:ok, %{data: %{"users" => [%{"id" => _id, "name" => "some name", "cameras" => []}]}}} = response
    end
  end
end
  