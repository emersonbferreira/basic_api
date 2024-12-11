defmodule BasicApi.Auth.UserAuth do
  alias BasicApi.Repo
  alias BasicApi.Models.User
  alias BasicApi.Auth.Guardian

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.check_pass(user, password) ->
        token = Guardian.generate_token(user)
        {:ok, token}

      true ->
        :error
    end
  end
end
