alias BasicApi.Repo
alias BasicApi.Models.User
alias BasicApi.Helpers.SeedHelper

case Repo.all(User) do
  [] ->
    SeedHelper.create_users()
    SeedHelper.create_cameras_for_users()

    IO.puts("Seed data successfully created!")

  _ ->
    IO.puts("Seed data already exists")
end
