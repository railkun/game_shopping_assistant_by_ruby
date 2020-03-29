require_relative 'bot_phrase'
require_relative 'store/steam'
require_relative 'store/gabestore'
require_relative 'store/steampay'
require_relative 'store/zaka_zaka'

require 'telegram/bot'

TOKEN = ''

Telegram::Bot::Client.run(TOKEN) do |bot|

  bot.listen do |message|

    case message.text

    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: BotPhrase.greeting(message.from.first_name))
    else
      bot.api.sendMessage(chat_id: message.chat.id, text:
        "
        Search result:
        #{Steam.game_search(message.text)}
        #{ZakaZaka.game_search(message.text)}
        #{Gabestore.game_search(message.text)}
        #{Steampay.game_search(message.text)}
        ")
    end
  end
end
