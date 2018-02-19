defmodule ExLogWeb.ServiceChannelTest do
  use ExLogWeb.ChannelCase

  alias ExLogWeb.ServiceChannel

  setup do
    {:ok, service} = ExLog.Logging.create_service(%{name: "some name"})
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ServiceChannel, "service:" <> to_string(service.id))

    {:ok, socket: socket, service: service}
  end

  @valid_attrs %{timestamp: ~N[2018-04-14 14:00:00.000000], location: "some location", message: "some message"}

  defp entry_fixture(attrs) do
    {:ok, entry} =
      attrs
      |> Enum.into(@valid_attrs)
      |> ExLog.Logging.create_entry()
    case attrs do
      %{service: service} ->
        changeset = ExLog.Logging.Entry.changeset(entry, %{"service_id" => service.id})
        ExLog.Repo.update!(changeset)
      _ -> entry
    end
  end

  test "broadcasts are pushed when a new log entry is created", %{service: service} do
    entry = entry_fixture(%{service: service})
    ServiceChannel.broadcast_create(entry)
    assert_broadcast "entry", @valid_attrs
  end

end
