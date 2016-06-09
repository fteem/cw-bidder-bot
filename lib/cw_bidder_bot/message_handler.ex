defmodule CwBidderBot.MessageHandler do
  require Logger

  @fb_page_access_token System.get_env("FB_PAGE_ACCESS_TOKEN")

  def handle(msg = %{message: %{text: text}}) do
    Logger.info "Sent text:\n#{inspect text}"

    buttons = [
      %{type: "postback", title: "Increase bid", payload: "PB_NAME"},
      %{type: "web_url", title: "See lot in broswer", url: "https://playoverwatch.com/en-us/heroes/bastion/"}
    ]

    message_body = """
    You have been overbid on AUCTION_NAME, please select an action. Ignore this
    message if you don't want to take any actions.
    """

    send_button_message(msg.sender.id, message_body, buttons)
    # incoming text message
  end

  def handle(msg) do
    Logger.info "Unhandled message:\n#{inspect msg}"
  end

  defp send_button_message(recipient, text, buttons) do
    payload = %{
      recipient: %{id: recipient},

      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: text,
            buttons: buttons
          }
        }
      }
    }

    Logger.info "Sending payload:\n#{inspect payload}"
    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{@fb_page_access_token}"
    headers = [{"Content-Type", "application/json"}]
    Logger.info(inspect HTTPoison.post!(url, Poison.encode!(payload), headers))
  end
end
