defmodule ZTD.Web.Controllers.Todo do
  use ZTD.Web, :controller

  alias ZTD.Todo


  @doc "GET: All Todo Items"
  def index(conn, _params) do
    render(conn, "index.html", items: Todo.all, mode: Todo.Config.mode)
  end

end
