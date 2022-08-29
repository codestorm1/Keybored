defmodule KeyboredUI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KeyboredUIWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: KeyboredUI.PubSub},
      # Start the Endpoint (http/https)
      KeyboredUIWeb.Endpoint,
      # Start a worker by calling: KeyboredUI.Worker.start_link(arg)
      # {KeyboredUI.Worker, arg}
      KeyboredUI.Inputter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KeyboredUI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KeyboredUIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
