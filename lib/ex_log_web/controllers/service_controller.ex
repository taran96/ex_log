defmodule ExLogWeb.ServiceController do
  use ExLogWeb, :controller

  alias ExLog.Logging
  alias ExLog.Logging.Service

  action_fallback ExLogWeb.FallbackController

  def index(conn, _params) do
    services = Logging.list_services()
    render(conn, "index.json", services: services)
  end

  def create(conn, %{"service" => service_params}) do
    with {:ok, %Service{} = service} <- Logging.create_service(service_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", service_path(conn, :show, service))
      |> render("show.json", service: service)
    end
  end

  def show(conn, %{"id" => id}) do
    service = Logging.get_service!(id)
    render(conn, "show.json", service: service)
  end

  def update(conn, %{"id" => id, "service" => service_params}) do
    service = Logging.get_service!(id)

    with {:ok, %Service{} = service} <- Logging.update_service(service, service_params) do
      render(conn, "show.json", service: service)
    end
  end

  def delete(conn, %{"id" => id}) do
    service = Logging.get_service!(id)
    with {:ok, %Service{}} <- Logging.delete_service(service) do
      send_resp(conn, :no_content, "")
    end
  end
end
