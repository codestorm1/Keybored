defmodule KeyboredUIWeb.PageController do
  use KeyboredUIWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
