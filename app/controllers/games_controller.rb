require 'open-uri'
require 'json'

class GamesController < ApplicationController

def generate_grid(grid_size)
  alphabet = ("a".."z").to_a
  selected_letters = []
  count = 0
  until count == grid_size.to_i
    selected_letters << alphabet[rand(0..26)]
    count += 1
  end
  return selected_letters
end

def get_api_answer(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  dictionary = open(url).read
  answer = JSON.parse(dictionary)
  return answer["found"]
end

def in_grid?(attempt, grid)
  attempt_letters = attempt.upcase.split("")
  letters_count = []
  grid_letters = grid.upcase.split(" ")
  attempt_letters.each do |letter|
    if grid_letters.include?(letter)
      letters_count << letter
    end
  end
  attempt_letters.length == letters_count.length
end

###############################################################

  def new
    @letters = generate_grid(rand(5..11))
  end

  def score
    @word = params[:game]
    @letters = params[:letters]
    answer = get_api_answer(@word)
    answer2 = in_grid?(@word ,@letters)
    if answer2 == false
      @message = "Sorry but #{@word} can't be built with #{@letters}!"
    elsif answer == false
      @message = "Sorry but #{@word} is not an English word!"
    elsif answer2 && answer
      @message = "Congratulations #{@word} is an English word!"
    end
  end
end

