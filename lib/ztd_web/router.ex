defmodule ZTD.Web.Router do
  use ZTD.Web, :router


  # Pipelines
  # ---------

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end



  # Routes
  # ------

  scope "/", ZTD.Web.Controllers do
    pipe_through :browser

    get "/", Todo, :index
  end


end
