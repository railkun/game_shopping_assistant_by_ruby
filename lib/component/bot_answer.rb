HREF = 'href'.freeze

require_relative 'stores/steam'
require_relative 'stores/gabestore'
require_relative 'stores/steampay'
require_relative 'stores/zaka_zaka'
require_relative 'bot_phrase'

class BotAnswer
  def bot_game_search_result(name)
    "
    #{Steam.search(name)}
    #{Gabestore.search(name)}
    #{Steampay.search(name)}
    #{ZakaZaka.search(name)}
    "
  end

  def bot_phrase_greeting(user_name)
    BotPhrase.greeting(user_name)
  end
end
