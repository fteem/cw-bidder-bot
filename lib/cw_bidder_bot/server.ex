defmodule CwBidderBot.Server do
  @default_port 4000

  def start_link(nil), do: start_server(@default_port)
  def start_link(port), do: port |> String.to_integer() |> start_server()

  defp start_server(port) do
    Plug.Adapters.Cowboy.http CwBidderBot.Router, [], port: port
  end

end
