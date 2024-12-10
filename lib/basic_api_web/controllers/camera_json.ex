defmodule BasicApiWeb.CameraJSON do
  alias BasicApi.Models.Camera

  @doc """
  Renders a list of cameras.
  """
  def index(%{cameras: cameras}) do
    %{data: for(camera <- cameras, do: data(camera))}
  end

  @doc """
  Renders a single camera.
  """
  def show(%{camera: camera}) do
    %{data: data(camera)}
  end

  defp data(%Camera{} = camera) do
    %{
      id: camera.id,
      name: camera.name,
      brand: camera.brand,
      enabled: camera.enabled,
      desabled_at: camera.desabled_at
    }
  end
end
