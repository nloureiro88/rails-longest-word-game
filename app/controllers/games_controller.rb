require 'time'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
    @start = Time.now
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @time_start = params[:time_start]
    @time_end = Time.now
    time = Time.parse(@time_end.to_s) - Time.parse(@time_start.to_s)
    score_calc = ([20 - time, 1].max / 20 * @word.length).round(2)
    @score = valid_word?(@word) && word_in_grid?(@word, @grid) ? score_calc : 0
    @message = generate_message(@word, @grid, @score)
  end

  private

  def generate_grid(grid_size)
    grid_array = []
    grid_size.times do
      grid_array << ('A'..'Z').to_a.sample
    end
    grid_array
  end

  def generate_message(word, grid, score)
    if !valid_word?(word)
      "#{word.capitalize} is not an english word!"
    elsif !word_in_grid?(word, grid)
      "#{word.capitalize} is not in the grid!"
    else
      "You have scored #{score} points!"
    end
  end

  def valid_word?(word)
    basic_url = 'https://wagon-dictionary.herokuapp.com/'
    url = basic_url + @word
    word_serialized = open(url).read
    word_hash = JSON.parse(word_serialized)
    word_hash['found']
  end

  def word_in_grid?(word, grid)
    word_hash = Hash.new(0)
    word.upcase.split('').each { |letter| word_hash[letter] += 1 }

    grid_hash = Hash.new(0)
    grid.upcase.split('').each { |letter| grid_hash[letter] += 1 }

    word_hash.keys.all? { |letter| word_hash[letter] <= grid_hash[letter] }
  end
end
