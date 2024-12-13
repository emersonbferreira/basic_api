defmodule BasicApi.Models do
  @moduledoc """
  The Models context.
  """

  import Ecto.Query, warn: false
  alias BasicApi.Repo

  alias BasicApi.Models.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
