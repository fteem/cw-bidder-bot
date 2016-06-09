defmodule CwBidderBot.MessageHandler do
  require Logger

  @fb_page_access_token System.get_env("FB_PAGE_ACCESS_TOKEN")

  def handle(msg = %{message: %{text: "Increase bid"}}) do
    text = "Your bid has been saved."

    payload = %{
      recipient: %{id: msg.sender.id},

      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "generic",
            text: text
          }
        }
      }
    }

    send_payload(payload)
  end

  def handle(%{ fb_uid: fb_uid, lot_link: lot_link, current_bid: current_bid, user_bid: user_bid, next_bid: next_bid }) do
    buttons = [
      %{type: "postback", title: "Increase bid", payload: "PB_NAME"},
      %{type: "web_url", title: "See lot in broswer", url: "https://playoverwatch.com/en-us/heroes/bastion/"}
    ]

    message_body = """
    You have been overbid on AUCTION_NAME, please select an action. Ignore this
    message if you don't want to take any actions.
    """

    payload = %{
      # 884577415002929 - Ilija
      recipient: %{
        id: fb_uid
      },
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: message_body,
            buttons: buttons
          }
        }
      }
    }
    send_payload(payload)
  end

  def handle(msg) do
    payload = %{
      recipient: %{ 
        id: msg.sender.id 
      },
      message: %{
        text: "Hey there, my name is Catawiki! How are you doing today?"
      }
    }

    Logger.info "Unhandled message:\n#{inspect msg}"

    send_payload(payload)
  end

  defp send_payload(payload) do
    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{@fb_page_access_token}"
    headers = [{"Content-Type", "application/json"}]
    Logger.info "Sending payload:\n#{inspect payload}"
    Logger.info(inspect HTTPoison.post!(url, Poison.encode!(payload), headers))
  end
end
