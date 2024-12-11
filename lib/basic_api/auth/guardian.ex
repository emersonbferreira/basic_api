defmodule BasicApi.Auth.Guardian do
  use Joken.Config

  @secret_key Application.compile_env(:basic_api, :secret_key)

  def generate_token(user) do
    payload = %{
      "user_id" => user.id,
      "email" => user.email
    }

    {:ok, token, _claims} = Joken.generate_and_sign(payload, %{key: @secret_key})
    token
  end

  def validate_token(token) do
    case Joken.verify_and_validate(token, %{key: @secret_key}) do
      {:ok, claims} -> {:ok, claims}
      _error -> :error
    end
  end
end
  