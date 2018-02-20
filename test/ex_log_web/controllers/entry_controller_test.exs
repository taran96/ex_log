defmodule ExLogWeb.EntryControllerTest do
  use ExLogWeb.ConnCase

  alias ExLog.Logging
  alias ExLog.Logging.Entry

  @create_attrs %{location: "some location", message: "some message", timestamp: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{location: "some updated location", message: "some updated message", timestamp: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{location: nil, message: nil, timestamp: nil}

  def fixture(:entry) do
    {:ok, entry} = Logging.create_entry(@create_attrs)
    entry
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all entries", %{conn: conn} do
      conn = get conn, entry_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create entry" do
    test "renders entry when data is valid", %{conn: conn} do
      conn = post conn, entry_path(conn, :create), entry: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, entry_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "location" => "some location",
        "message" => "some message",
        "timestamp" => "2010-04-17T14:00:00.000000"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, entry_path(conn, :create), entry: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "sends a broadcast on the service channel", %{conn: conn} do
      {:ok, service} = ExLog.Logging.create_service(%{name: "some name"})
      ExLogWeb.Endpoint.subscribe("service:#{service.id}")
      attrs = Map.put(@create_attrs, :service_id, service.id)
      conn = post conn, entry_path(conn, :create), entry: attrs
      assert json_response(conn, 201)
      assert_receive %Phoenix.Socket.Broadcast{event: "entry", payload: ^attrs}
      ExLogWeb.Endpoint.unsubscribe("service:#{service.id}")
    end
  end

  describe "update entry" do
    setup [:create_entry]

    test "renders entry when data is valid", %{conn: conn, entry: %Entry{id: id} = entry} do
      conn = put conn, entry_path(conn, :update, entry), entry: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, entry_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "location" => "some updated location",
        "message" => "some updated message",
        "timestamp" => "2011-05-18T15:01:01.000000"}
    end

    test "renders errors when data is invalid", %{conn: conn, entry: entry} do
      conn = put conn, entry_path(conn, :update, entry), entry: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete entry" do
    setup [:create_entry]

    test "deletes chosen entry", %{conn: conn, entry: entry} do
      conn = delete conn, entry_path(conn, :delete, entry)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, entry_path(conn, :show, entry)
      end
    end
  end

  defp create_entry(_) do
    entry = fixture(:entry)
    {:ok, entry: entry}
  end
end
