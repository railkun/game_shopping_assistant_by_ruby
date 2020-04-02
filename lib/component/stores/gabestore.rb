GABESTORE_URL        = 'https://gabestore.ru'.freeze
GABESTORE_SEARCH_URL = 'https://gabestore.ru/catalog?ProductFilter%5Bsearch%5D='.freeze
GABESTORE_PARS_LIST  = '//div[@class="products-list js-catalog-loadout"]'.freeze
GABESTORE_PARS_GAME  = "//font[@class='currencyPrice']".freeze

class Gabestore
  def self.search(message)
    game_name = message.split(/\W+/).join('+').downcase
    new.search(game_name)
  end

  def search(game_name)
    begin
      url = GABESTORE_SEARCH_URL + game_name
      doc = Nokogiri::HTML(URI.parse(url).open)
    rescue OpenURI::HTTPError => e
      raise e unless e.message == '404 Not Found'
    end

    pars_list(doc)
  end

  def pars_list(doc)
    if doc.xpath(GABESTORE_PARS_LIST).children[3].nil?
      'The game is not present in the Gabestore'
    else
      list_item = doc.xpath(GABESTORE_PARS_LIST).children[3].children[1].attributes[HREF].value
      game_url  = GABESTORE_URL + list_item
      pars_game_price(game_url)
    end
  end

  def pars_game_price(game_url)
    doc = Nokogiri::HTML(URI.parse(game_url).open)
    price = doc.xpath(GABESTORE_PARS_GAME).children[3].text.to_i
    "
    Gabestore: #{price} RUB
     #{game_url}
    "
  end
end
