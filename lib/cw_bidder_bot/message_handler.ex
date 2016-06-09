defmodule CwBidderBot.MessageHandler do
  require Logger

  def handle(msg = %{message: %{text: _text}}) do
    # incoming text message
  end

  def handle(msg) do
    Logger.info "Unhandled message:\n#{inspect msg}"
  end
end
