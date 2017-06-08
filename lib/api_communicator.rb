require 'rest-client'
require 'json'
require 'pry'

def get_hash_from_api(url)
  raw_data = RestClient.get(url)
  hash = JSON.parse(raw_data)
  hash
end


def get_character_movies_from_api(character)
  ###NEED TO GET ALL PAGES
  if !find_character_hash(character)
    puts "You spelled that wrong please enter a character"
    character = gets.chomp
  else
    film_urls_array = find_character_hash(character)["films"]
    films_array = film_urls_array.each_with_object([]) do |film_url, temp_array|
      film_hash = get_hash_from_api(film_url)
      temp_array << film_hash
    end
  end

  films_array

end

def find_character_hash(character)

  paged_hash = get_hash_from_api('http://www.swapi.co/api/people/')

  #Add all pages to hash_array
  hash_array = []
  hash_array += paged_hash["results"]
  while paged_hash["next"]
    paged_hash = get_hash_from_api(paged_hash["next"])
    hash_array += paged_hash["results"]
  end

  #Merge all hashes into one big hash
  character_hash = hash_array.each_with_object({}) do |hash, temp_hash|
    temp_hash[hash["name"]]= hash
  end
  character_hash[character]
end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.each do |film|
    puts film["title"]
  end

end


# ##Version for Dan
# def parse_character_movies(films_hash, fields)
#   # some iteration magic and puts out the movies in a nice list
#   films_hash.each do |film|
#     fields.each do |field|
#       puts "The #{field} is..."
#       puts "#{film[field]}"
#     end
#   end
#
# end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end


show_character_movies("Han Solo")
# x = get_character_movies_from_api("Luke Skywalker")
# fields = ["episode_id", "opening_crawl", "title"]
# parse_character_movies(x, fields)
# BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
