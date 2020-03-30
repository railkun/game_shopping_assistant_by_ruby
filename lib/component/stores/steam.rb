class Steam
  def self.search(message)
    game_name = message.split(/\W+/).join('+').downcase

    url = STEAM_URL + game_name
    doc = Nokogiri::HTML(URI.parse(url).open)
    game_link = doc.xpath(STEAM_SEARCH_PARS)[121].attributes[HREF].value

    if NO_RESULT_SEARCH.include?(game_link)
      'The game is not present in the Steam'
    else
      doc = Nokogiri::HTML(URI.parse(game_link).open)
      price = doc.xpath(STEAM_PARS)[0].children[0].text.to_i

      if price.zero?
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
