defmodule BasicApi.Services.EmailSenderTest do
  use ExUnit.Case
  use BasicApi.DataCase

  import Mock
  import BasicApi.ModelsFixtures
  
  alias BasicApi.Services.EmailSender
  alias BasicApi.Mailer
  describe "notify_users" do
    test "notify_users sends notifications to users with Hikvision cameras" do
      user_1 = user_fixture(%{email: "email_1@teste"})
      user_2 = user_fixture(%{email: "email_2@teste"})
      camera_fixture(user_1)
      camera_fixture(user_2)

      email_1 = build_email(user_1)
      email_2 = build_email(user_2)

      with_mock Mailer, [deliver: fn _ -> :ok end] do
        EmailSender.notify_users()
        :timer.sleep(500)

        assert called Mailer.deliver(email_1)
        assert called Mailer.deliver(email_2)
      end
    end
  end

  def build_email(user) do
    Swoosh.Email.new()
    |> Swoosh.Email.to(user.email)
    |> Swoosh.Email.from("no-reply@basicapi.com")
    |> Swoosh.Email.subject("Notification for Hikvision cams")
    |> Swoosh.Email.html_body("<h1>Notification for Hikvision cams</h1>")
  end
end
