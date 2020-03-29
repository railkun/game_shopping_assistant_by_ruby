require 'open-uri'
require 'nokogiri'
require 'mechanize'

NO_RESULT_SEARCH = ['https://steamcommunity.com/games/593110/partnerevents/view/1714119088658959583']

class Steam

  def self.game_search(message)

    game_name = message.split(/\W+/).join('+').downcase

    url = "https://store.steampowered.com/search/?term=#{game_name}"
    doc = Nokogiri::HTML(open(url))
    game_link = doc.xpath("//a[@href]")[121].attributes["href"].value

    if NO_RESULT_SEARCH.include?(game_link)
      steam = 'The game is not present in the Steam'
    else
      doc = Nokogiri::HTML(open(game_link))
      price = doc.xpath("//div[@class='game_purchase_price price']")[0].children[0].text.to_i

      steam = if price == 0
        "
        The game is free in the Steam
        #{game_link}
        "
      else
        "
        Steam: #{price} UAH
         #{game_link}
        "
      end
    end
  end
end
