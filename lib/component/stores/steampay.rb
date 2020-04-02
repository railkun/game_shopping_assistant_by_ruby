STEAMPAY_URL  = 'https://steampay.com/game/'.freeze
STEAMPAY_PARS = "//div[@class='product__current-price']".freeze

class Steampay
  def self.search(message)
    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = STEAMPAY_URL + game_name
      doc = Nokogiri::HTML(URI.parse(url).open)
    rescue OpenURI::HTTPError => e
      raise e unless e.message == '404 Not Found'
    end

    if doc.nil?
      'The game is not present in the Steampay'
    else
      price = doc.xpath(STEAMPAY_PARS).children[0].text.split(/\W+/)[1].to_i
      "
      Steampay: #{price} RUB
       #{url}
      "
    end
  end
end
