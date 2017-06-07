require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)

  film_urls_array = find_character_hash(character)["films"]

  films_array = film_urls_array.each_with_object([]) do |film_url, temp_array|
    film_raw_json = RestClient.get(film_url)
    film_hash = JSON.parse(film_raw_json)
    temp_array << film_hash
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
ends


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
 raw_movies = get_character_movies_from_api("Luke Skywalker")

 parse_character_movies(raw_movies)
