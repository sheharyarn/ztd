defmodule ZTDWeb.PageController do
  use ZTDWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
