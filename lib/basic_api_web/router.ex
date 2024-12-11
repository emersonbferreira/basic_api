defmodule BasicApiWeb.Router do
  use BasicApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BasicApiWeb do
    pipe_through [:api]

    scope "/users" do
      resources "/", UserController, except: [:new, :edit]
    end

    scope "/cameras" do
      resources "/", CameraController, except: [:new, :edit]

      get "/#{:camera_id}", CameraController, :show
    end

    post "/login", SessionController, :create
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
