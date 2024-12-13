defmodule BasicApi.Auth.UserAuth do
  alias BasicApi.Repo
  alias BasicApi.Models.User
  alias BasicApi.Auth.JWTToken

  @secret_key Application.compile_env(:joken, :default_signer)

  def authenticate_user(email, password) do
    signer = Joken.Signer.create("HS256", @secret_key)

    with %User{} = user <- Repo.get_by(User, email: email),
          true <- Bcrypt.verify_pass(password, user.password_hash),
          {:ok, token, _claims} <- JWTToken.generate_and_sign(%{"email" => user.email}, signer) do
      {:ok, token}
    else
      _ ->
        :error
    end 
  end
end
