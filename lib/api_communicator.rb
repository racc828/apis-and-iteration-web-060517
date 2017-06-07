require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)

  if !find_character_hash(character)
    puts "You spelled that wrong please enter a character"
    character = gets.chomp
  else
    film_urls_array = find_character_hash(character)["films"]

    films_array = film_urls_array.each_with_object([]) do |film_url, temp_array|
    film_raw_json = RestClient.get(film_url)
    film_hash = JSON.parse(film_raw_json)
    temp_array << film_hash
    end
  end

  films_array

end

def find_character_hash(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  #parse data
  character_hash = JSON.parse(all_characters)

  #Array of character hashes
  the_character = character_hash["results"].find do |char_hash|
    char_hash["name"] == character
  end

  the_character
end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.each do |film|
    puts film["title"]
  end

end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
