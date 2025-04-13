require 'rails_helper'

RSpec.feature "Rating a Movie", type: :feature do
  let!(:movie) { Movie.create!(title: "Inception") }

  before do
    visit '/sign_up'
    fill_in "Username", with: "user1"
    fill_in "Email", with: "user1@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
  end

  scenario "Successfully rate a movie" do
    visit movie_path(movie)
    fill_in "Your rating", with: "5"
    click_button "Submit Rating"

    expect(page).to have_content("5 stars")
  end

  scenario "Edit a rating" do
    visit movie_path(movie)
    fill_in "Your rating", with: "3"
    click_button "Submit Rating"
    fill_in "Your rating", with: "4"
    click_button "Submit Rating"

    expect(page).to have_content("4 stars")
  end
end