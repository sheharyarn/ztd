defmodule ZTD.Web.ErrorViewTest do
  use ZTD.Tests.Support.ConnCase, async: true
  import Phoenix.View


  describe "Error Pages" do
    @view ZTD.Web.Views.Error

    test "renders 404.html" do
      assert render_to_string(@view, "404.html", []) == "Not Found"
    end

    test "renders 500.html" do
      assert render_to_string(@view, "500.html", []) == "Internal Server Error"
    end
  end

end
