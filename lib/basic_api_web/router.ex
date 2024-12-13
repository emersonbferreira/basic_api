defmodule BasicApiWeb.Router do
  use BasicApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_auth do
    plug BasicApiWeb.Plugs.RequireAuth
  end

  scope "/" do
    scope "/notify_users", BasicApiWeb do
      pipe_through [:api, :require_auth]

      post "/", UserController, :notify_users
    end

    scope "/cameras" do
      pipe_through [:require_auth]

      get "/", Absinthe.Plug,
        schema: BasicApiWeb.Schema
    end

    scope "/users", BasicApiWeb do
      pipe_through [:api]

      post "/", UserController, :create
      post "/login", SessionController, :create
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:basic_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BasicApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
