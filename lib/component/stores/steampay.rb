STEAMPAY_URL        = 'https://steampay.com'.freeze
STEAMPAY_SEARCH_URL = 'https://steampay.com/search?q='.freeze
STEAMPAY_PARS_LIST  = '//div[@class="catalog catalog--main"]'.freeze
STEAMPAY_PARS_GAME  = "//div[@class='product__current-price']".freeze

class Steampay
  def self.search(message)
    game_name = message.split(/\W+/).join('+').downcase
    new.search(game_name)
  end

  def search(game_name)
    begin
      url = STEAMPAY_SEARCH_URL + game_name
      doc = Nokogiri::HTML(URI.parse(url).open)
    rescue OpenURI::HTTPError => e
      raise e unless e.message == '404 Not Found'
    end

    pars_list(doc)
  end

  def pars_list(doc)
    if doc.xpath(STEAMPAY_PARS_LIST).children[1].nil?
      'The game is not present in the Steampay'
    else
      list_item = doc.xpath(STEAMPAY_PARS_LIST).children[1].attributes[HREF].value
      game_url  = STEAMPAY_URL + list_item
      pars_game_price(game_url)
    end
  end

  def pars_game_price(game_url)
    doc = Nokogiri::HTML(URI.parse(game_url).open)
    price = doc.xpath(STEAMPAY_PARS_GAME).children[0].text.to_i
    "
    Steampay: #{price} RUB
     #{game_url}
    "
  end
end
