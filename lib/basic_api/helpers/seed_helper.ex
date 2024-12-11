defmodule BasicApi.Helpers.SeedHelper do
  alias BasicApi.Repo
  alias BasicApi.Models.{User, Camera}
  
  @camera_brands ["Intelbras", "Hikvision", "Giga", "Vivotek"]

  def create_users() do
    users_data = generate_user_data(1000)

    Repo.insert_all(User, users_data)
  end
  
  def create_cameras_for_users() do
      users = Repo.all(User)

      Enum.each(users, fn user ->
        cameras = create_cameras(user, user.enabled)

        Repo.insert_all(Camera, cameras)
    end)
  end
  
  defp create_cameras(user, false), do: Enum.map(1..50, fn _ -> generate_camera(user, false) end)
  
  defp create_cameras(user, true) do
    enabled_camera = generate_camera(user, true)
    random_status_cameras = Enum.map(1..49, fn _ -> generate_camera(user, Enum.random([true, false])) end)
  
    Enum.concat([enabled_camera], random_status_cameras)
  end

  defp generate_user_data(count) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)
    Enum.map(1..count, fn i ->
      %{
        name: "User #{i}",
        email: "user#{i}@example.com",
        password_hash: "password#{i}#{:rand.uniform(100000)}",
        enabled: Enum.random([true, false]),
        inserted_at: time,
        updated_at: time
      }
    end)  
  end
  
  defp generate_camera(user, status) do
    time = DateTime.utc_now() |> DateTime.truncate(:second)
    %{
      name: "Camera-#{:rand.uniform(1000)}",
      brand: Enum.random(@camera_brands),
      enabled: status,
      user_id: user.id,
      inserted_at: time,
      updated_at: time,
      desabled_at: status == false && time || nil
    }
  end
end
