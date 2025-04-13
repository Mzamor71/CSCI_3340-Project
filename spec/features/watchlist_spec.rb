require 'rails_helper'

RSpec.feature "Watchlist Features", type: :feature do
  let!(:movie) { Movie.create!(title: "The Prestige") }

  before do
    visit '/sign_up'
    fill_in "Username", with: "watcher"
    fill_in "Email", with: "watcher@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
  end

  scenario "Adding a movie to the watchlist" do
    visit movie_path(movie)
    click_button "Add to Watchlist"

    expect(page).to have_content("In your Watchlist")
  end

  scenario "Removing a movie from the watchlist" do
    visit movie_path(movie)
    click_button "Add to Watchlist"
    click_button "Remove from Watchlist"

    expect(page).to have_content("Add to Watchlist")
  end
end
