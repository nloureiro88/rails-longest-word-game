require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "span", count: 10
  end

  test "Random word, get a message that the word is not in the grid" do
    visit new_url
    assert test: "New game"
    assert_selector "h2", ""
  end

  test "One-letter consonant word, get a message it's not a valid English word" do
    visit new_url
    assert test: "New game"
    assert_selector "h2", ""
  end

  test "Valid English word, get a message that the word is not in the grid" do
    visit new_url
    assert test: "New game"
    assert_selector "h2", ""
  end
end
