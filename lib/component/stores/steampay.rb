STEAMPAY_STORE_URL   = 'https://steampay.com/game/'
STEAMPAY_GAME_PARS   = "//div[@class='product__current-price']"

class Steampay

  def self.game_search(message)

    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = STEAMPAY_STORE_URL + game_name
      doc = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        # handle 404 error
      else
        raise e
      end
    end

    steampay = if doc.nil?
      'The game is not present in the Steampay'
    else
      price = doc.xpath(STEAMPAY_GAME_PARS).children[0].text.split(/\W+/)[1].to_i
      "
      Steampay: #{price} RUB
       #{url}
      "
    end
  end
end
