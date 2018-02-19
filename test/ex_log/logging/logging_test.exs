defmodule ExLog.LoggingTest do
  use ExLog.DataCase

  alias ExLog.Logging

  describe "services" do
    alias ExLog.Logging.Service

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Logging.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Logging.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Logging.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Logging.create_service(@valid_attrs)
      assert service.name == "some name"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logging.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, service} = Logging.update_service(service, @update_attrs)
      assert %Service{} = service
      assert service.name == "some updated name"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Logging.update_service(service, @invalid_attrs)
      assert service == Logging.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Logging.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Logging.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Logging.change_service(service)
    end
  end
end
