require 'open-uri'
require 'nokogiri'
require 'mechanize'

class Steampay

  def self.game_search(message)

    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = "https://steampay.com/game/#{game_name}"
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
      price = doc.xpath("//div[@class='product__current-price']").children[0].text.split(/\W+/)[1].to_i
      "
      Steampay: #{price} RUB
       #{url}
      "
    end
  end
end
