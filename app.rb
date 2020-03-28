require 'open-uri'
require 'pry'
require 'nokogiri'
require 'mechanize'
require 'yaml'
require 'telegram/bot'

token = ''

def zaka_zaka_shop(game_name)
  begin
    url = "https://zaka-zaka.com/game/#{game_name}"
    doc = Nokogiri::HTML(open(url))
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      # handle 404 error
    else
      raise e
    end
  end

  if doc.nil?
    zaka_zaka = 'The game is not present in the Zaka-Zaka'
  else
    price = doc.xpath("//div[@class='price']").children[0].text.split(/\W+/)[1].to_i
    zaka_zaka = "
    Zaka-Zaka: #{price} rub
    #{url}
    "
  end
end

def gabestore_shop(game_name)
  begin
    url = "https://gabestore.ru/game/#{game_name}"
    doc = Nokogiri::HTML(open(url))
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      # handle 404 error
    else
      raise e
    end
  end

  if doc.nil?
    gabestore_shop = 'The game is not present in the Gabestore'
  else
    price = doc.xpath("//font[@class='currencyPrice']").children[3].text.split(/\W+/)[1].to_i
    gabestore_shop = "
    Gabestore: #{price} rub
    #{url}
    "
  end
end

def steampay_shop(game_name)
  begin
    url = "https://steampay.com/game/#{game_name}"
    doc = Nokogiri::HTML(open(url))
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      # handle 404 error
    else
      raise e
    end
  end

  if doc.nil?
    steampay = 'The game is not present in the Steampay'
  else
    price = doc.xpath("//div[@class='product__current-price']").children[0].text.split(/\W+/)[1].to_i
    steampay = "
    Steampay: #{price} rub
    #{url}
    "
  end
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    game_name = message.text.split(/\W+/).join('-').downcase

    case game_name
    when 'start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: zaka_zaka_shop(game_name))
      bot.api.sendMessage(chat_id: message.chat.id, text: gabestore_shop(game_name))
      bot.api.sendMessage(chat_id: message.chat.id, text: steampay_shop(game_name))
    end
  end
end
