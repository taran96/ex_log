defmodule ExLogWeb.ServiceChannel do
  use ExLogWeb, :channel

  def join("service:" <> service_id, payload, socket) do
    if authorized?(payload) do
      {:ok, "Joined Service #{service_id}", socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(_payload) do
    true
  end

  @doc """
  This function will be called when a new log entry is created and it will
  broadcast it out to all clients subscribed to the service.
  """
  def broadcast_create(entry) do
    payload = %{
      location: entry.location,
      message: entry.message,
      service_id: entry.service_id,
      timestamp: entry.timestamp,
      level_id: entry.level_id,
    }
    ExLogWeb.Endpoint.broadcast!("service:#{entry.service_id}", "entry", payload)
  end
end
