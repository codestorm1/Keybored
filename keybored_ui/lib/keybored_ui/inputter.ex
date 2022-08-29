defmodule KeyboredUI.Inputter do
  use GenServer

  def start_link(_) do
    GenServer.start_link(KeyboredUI.Inputter, nil, name: Keybored.Inputter)
  end

  @impl true
  def init(_) do
    devices =
      InputEvent.enumerate()
      |> Enum.map(fn {device, info} ->
        {:ok, _pid} = InputEvent.start_link(device)
        {device, info}
      end)
      |> Map.new()

    {:ok, devices}
  end

  @impl true
  def handle_call(:fetch, _, devices) do
    {:reply, devices, devices}
  end

  @impl true
  def handle_info({:input_event, _device, _values} = event, devices) do
    Phoenix.PubSub.broadcast!(KeyboredUI.PubSub, "inputs", event)
    {:noreply, devices}
  end
end
