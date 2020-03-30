ZAKAZAKA_STORE_URL   = 'https://zaka-zaka.com/game/'
ZAKAZAKA_GAME_PARS   = "//div[@class='price']"

class ZakaZaka

  def self.game_search(message)

    game_name = message.split(/\W+/).join('-').downcase

    if game_name == 'dota-2'
      'The game is not present in the Zaka-Zaka'
    else
      begin
        url = ZAKAZAKA_STORE_URL + game_name
        doc = Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found'
          # handle 404 error
        else
          raise e
        end
      end

      zaka_zaka = if doc.nil?
        'The game is not present in the Zaka-Zaka'
      else
        price = doc.xpath(ZAKAZAKA_GAME_PARS).children[0].text.split(/\W+/)[1].to_i
        "
        Zaka-Zaka: #{price} RUB
         #{url}
        "
      end
    end

  end
end
