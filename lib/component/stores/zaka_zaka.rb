class ZakaZaka
  def self.search(message)
    game_name = message.split(/\W+/).join('-').downcase

    if game_name == 'dota-2'
      'The game is not present in the Zaka-Zaka'
    else

      begin
        url = ZAKAZAKA_URL + game_name
        doc = Nokogiri::HTML(URI.parse(url).open)
      rescue OpenURI::HTTPError => e
        raise e unless e.message == NOT_FOUND
      end

      if doc.nil?
        'The game is not present in the Zaka-Zaka'
      else
        price = doc.xpath(ZAKAZAKA_PARS).children[0].text.split(/\W+/)[1].to_i
        "
        Zaka-Zaka: #{price} RUB
         #{url}
        "
      end
    end
  end
end
