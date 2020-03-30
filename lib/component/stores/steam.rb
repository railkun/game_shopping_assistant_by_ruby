NO_RESULT_SEARCH  = ['https://steamcommunity.com/games/593110/partnerevents/view/1714119088658959583']
STEAM_STORE_URL   = 'https://store.steampowered.com/search/?term='
STEAM_SEARCH_PARS = "//a[@href]"
STEAM_GAME_PARS   = "//div[@class='game_purchase_price price']"

class Steam

  def self.game_search(message)

    game_name = message.split(/\W+/).join('+').downcase

    url = STEAM_STORE_URL + game_name
    doc = Nokogiri::HTML(open(url))
    game_link = doc.xpath(STEAM_SEARCH_PARS)[121].attributes["href"].value

    if NO_RESULT_SEARCH.include?(game_link)
      steam = 'The game is not present in the Steam'
    else
      doc = Nokogiri::HTML(open(game_link))
      price = doc.xpath(STEAM_GAME_PARS)[0].children[0].text.to_i

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
