require 'open-uri'
require 'nokogiri'
require 'mechanize'

class Gabestore

  def self.game_search(message)

    game_name = message.split(/\W+/).join('-').downcase

    begin
      url = "https://gabestore.ru/game/#{game_name}"
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
      price = doc.xpath("//font[@class='currencyPrice']").children[3].text.split(/\W+/)[1].to_i
      "
      Gabestore: #{price} RUB
       #{url}
      "
    end
  end
end
