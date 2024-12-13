defmodule BasicApi.Services.EmailSender do
  import Ecto.Query

  alias BasicApi.{Repo, Mailer}
  alias BasicApi.Models.User

  def notify_users(brand \\ "Hikvision") do
    query = 
      from u in User,
      join: c in assoc(u, :camera),
      where: u.enabled and c.brand == ^brand,
      select: u

    {:ok, Repo.all(query)
    |> Enum.each(fn user -> 
      Task.async(fn -> send_notification(user) end)
    end)}
  end

  defp send_notification(user) do
    email = Swoosh.Email.new()
    |> Swoosh.Email.to(user.email)
    |> Swoosh.Email.from("no-reply@basicapi.com")
    |> Swoosh.Email.subject("Notification for Hikvision cams")
    |> Swoosh.Email.html_body("<h1>Notification for Hikvision cams</h1>")

    Mailer.deliver(email)
  end
end
