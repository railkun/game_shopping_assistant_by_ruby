require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'telegram/bot'

require_relative 'component/bot_answer'
require_relative '../constant'
require_relative '../secret_token'

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text

    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: BOT_ANSWER.bot_phrase_greeting(message.from.first_name))
    else
      bot.api.sendMessage(chat_id: message.chat.id, text:
        "
        Search result:
        #{BOT_ANSWER.bot_game_search_result(message.text)}
        ")
    end
  end
end
