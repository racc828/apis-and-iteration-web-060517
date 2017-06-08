#!/usr/bin/env ruby

require_relative "../lib/api_communicator.rb"
require_relative "../lib/command_line_interface.rb"

welcome

character = nil
until find_character_hash(character)
  character = get_character_from_user
end

if character
  show_character_movies(character)
end
