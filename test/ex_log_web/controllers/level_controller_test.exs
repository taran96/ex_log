defmodule ExLogWeb.LevelControllerTest do
  use ExLogWeb.ConnCase

  alias ExLog.Logging
  alias ExLog.Logging.Level

  @create_attrs %{name: "some name", priority: 42}
  @update_attrs %{name: "some updated name", priority: 43}
  @invalid_attrs %{name: nil, priority: nil}

  def fixture(:level) do
    {:ok, level} = Logging.create_level(@create_attrs)
    level
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all levels", %{conn: conn} do
      conn = get conn, level_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create level" do
    test "renders level when data is valid", %{conn: conn} do
      conn = post conn, level_path(conn, :create), level: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, level_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "priority" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, level_path(conn, :create), level: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update level" do
    setup [:create_level]

    test "renders level when data is valid", %{conn: conn, level: %Level{id: id} = level} do
      conn = put conn, level_path(conn, :update, level), level: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, level_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "priority" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, level: level} do
      conn = put conn, level_path(conn, :update, level), level: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete level" do
    setup [:create_level]

    test "deletes chosen level", %{conn: conn, level: level} do
      conn = delete conn, level_path(conn, :delete, level)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, level_path(conn, :show, level)
      end
    end
  end

  defp create_level(_) do
    level = fixture(:level)
    {:ok, level: level}
  end
end
