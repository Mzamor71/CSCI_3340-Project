require 'rails_helper'

RSpec.feature "Search Feature", type: :feature do
  let!(:movie1) { Movie.create!(title: "Dunkirk", genre: "War") }
  let!(:movie2) { Movie.create!(title: "Interstellar", genre: "Science Fiction") }

  scenario "Searching for a movie" do
    visit root_path
    fill_in "Search", with: "Dunkirk"
    click_button "Search"

    expect(page).to have_content("Dunkirk")
    expect(page).not_to have_content("Interstellar")
  end

  scenario "Filtering movies by genre" do
    visit root_path
    select "Science Fiction", from: "Genre"
    click_button "Filter"

    expect(page).to have_content("Interstellar")
    expect(page).not_to have_content("Dunkirk")
  end
end
