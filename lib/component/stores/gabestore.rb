class Gabestore
  def self.search(message)
    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = GABESTORE_URL + game_name
      doc = Nokogiri::HTML(URI.parse(url).open)
    rescue OpenURI::HTTPError => e
      raise e unless e.message == NOT_FOUND
    end

    if doc.nil?
      'The game is not present in the Gabestore'
    else
      price = doc.xpath(GABESTORE_PARS).children[3].text.split(/\W+/)[1].to_i
      "
      Gabestore: #{price} RUB
       #{url}
      "
    end
  end
end
