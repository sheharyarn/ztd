defmodule ZTD.Web.PageController do
  use ZTD.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
