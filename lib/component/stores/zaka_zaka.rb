ZAKAZAKA_SEARCH_URL = 'https://zaka-zaka.com/search/?ask='.freeze
ZAKAZAKA_PARS_LIST  = '//div[@class="search-results"]'.freeze
ZAKAZAKA_PARS_GAME  = "//div[@class='price']".freeze

class ZakaZaka
  def self.search(message)
    game_name = message.split(/\W+/).join('+').downcase
    new.search(game_name)
  end

  def search(game_name)
    begin
      url = ZAKAZAKA_SEARCH_URL + game_name
      doc = Nokogiri::HTML(URI.parse(url).open)
    rescue OpenURI::HTTPError => e
      raise e unless e.message == '404 Not Found'
    end

    pars_list(doc)
  end

  def pars_list(doc)
    if doc.xpath(ZAKAZAKA_PARS_LIST).children[3].text.split(/\W+/).empty?
      'The game is not present in the Zaka-Zaka'
    else
      game_url = doc.xpath(ZAKAZAKA_PARS_LIST).children[3].attributes[HREF].value
      pars_game_price(game_url)
    end
  end

  def pars_game_price(game_url)
    doc = Nokogiri::HTML(URI.parse(game_url).open)
    price = doc.xpath(ZAKAZAKA_PARS_GAME).children[0].text.to_i
    "
    Zaka-Zaka: #{price} RUB
     #{game_url}
    "
  end
end
