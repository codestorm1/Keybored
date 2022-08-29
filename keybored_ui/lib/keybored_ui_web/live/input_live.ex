defmodule KeyboredUIWeb.InputLive do
  use KeyboredUIWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    devices = GenServer.call(Keybored.Inputter, :fetch)

    Phoenix.PubSub.subscribe(KeyboredUI.PubSub, "inputs")

    {:ok, assign(socket, devices: devices, events: [], dot: {50, 50})}
  end

  @impl true
  def handle_info({:input_event, device, values}, socket) do
    events = [{device, values} | socket.assigns.events]
    dot = process_movements(socket.assigns.dot, values)

    {:noreply, assign(socket, events: events, dot: dot)}
  end

  defp process_movements(dot, []) do
    dot
  end

  defp process_movements({x, y} = dot, [value | values]) do
    dot =
      case value do
        {:ev_rel, :rel_x, points} -> {x + points, y}
        {:ev_rel, :rel_y, points} -> {x, y + points}
        {:ev_key, :key_up, 0} -> {x, y - 5}
        {:ev_key, :key_down, 0} -> {x, y + 5}
        {:ev_key, :key_left, 0} -> {x - 5, y}
        {:ev_key, :key_right, 0} -> {x + 5, y}
        _ -> dot
      end

    process_movements(dot, values)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <svg viewBox="0 0 100 100" style="position: absolute; top: 0; left: 0; height: 100vh; width: 100vw;">
      <circle cx={elem(@dot, 0)} cy={elem(@dot, 1)} r="6" />
    </svg>

    <div style="position: relative; max-height: 800px; overflow: hidden;">
    <%= for {d, e} <- Enum.take(@events,100) do %>
      <div><%= @devices[d].name %>: <%= inspect(e) %></div>
    <% end %>
    </div>
    """
  end
end
