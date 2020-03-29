require 'open-uri'
require 'pry'
require 'nokogiri'
require 'mechanize'
require 'yaml'
require 'telegram/bot'

token = ''

NO_RESULT_SEARCH = ['https://steamcommunity.com/games/593110/partnerevents/view/1714119088658959583']

def steam_shop(game_name_for_steam)
  url = "https://store.steampowered.com/search/?term=#{game_name_for_steam}"
  doc = Nokogiri::HTML(open(url))
  game_link = doc.xpath("//a[@href]")[121].attributes["href"].value

  if NO_RESULT_SEARCH.include?(game_link)
    steam = 'The game is not present in the Steam'
  else
    doc = Nokogiri::HTML(open(game_link))
    price = doc.xpath("//div[@class='game_purchase_price price']")[0].children[0].text.to_i
    if price == 0
      steam = "
      The game is free in the Steam
      #{game_link}
      "
    else
      steam = "
      Steam: #{price} UAH
      #{game_link}
      "
    end
  end
end

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
    Zaka-Zaka: #{price} RUB
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
    Gabestore: #{price} RUB
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
    Steampay: #{price} RUB
    #{url}
    "
  end
end

def greeting(user_name)
  greeting = "
  Hello, #{user_name}
  I`m game shopping assistant
  Enter a name for the game and
  I'm looking for this game price and
  link to the store where it can be bought
  "
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    game_name = message.text.split(/\W+/).join('-').downcase

    game_name_for_steam = message.text.split(/\W+/).join('+').downcase

    case game_name
    when 'start'
      bot.api.sendMessage(chat_id: message.chat.id, text: greeting(message.from.first_name))
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: steam_shop(game_name_for_steam))
      bot.api.sendMessage(chat_id: message.chat.id, text: zaka_zaka_shop(game_name))
      bot.api.sendMessage(chat_id: message.chat.id, text: gabestore_shop(game_name))
      bot.api.sendMessage(chat_id: message.chat.id, text: steampay_shop(game_name))
    end
  end
end
