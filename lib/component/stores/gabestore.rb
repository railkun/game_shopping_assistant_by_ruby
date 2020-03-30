GABESTORE_STORE_URL = 'https://gabestore.ru/game/'
GABESTORE_GAME_PARS = "//font[@class='currencyPrice']"

class Gabestore

  def self.game_search(message)

    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = GABESTORE_STORE_URL + game_name
      doc = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        # handle 404 error
      else
        raise e
      end
    end

    gabestore = if doc.nil?
      'The game is not present in the Gabestore'
    else
      price = doc.xpath(GABESTORE_GAME_PARS).children[3].text.split(/\W+/)[1].to_i
      "
      Gabestore: #{price} RUB
       #{url}
      "
    end
  end
end
