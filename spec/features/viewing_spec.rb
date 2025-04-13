require 'rails_helper'

RSpec.feature "Viewing Features", type: :feature do
  let!(:movie) { Movie.create!(title: "Memento", description: "A mind-bending thriller", director: "Christopher Nolan", release_year: 2000) }

  scenario "Viewing average rating after multiple users rate a movie" do
    visit '/sign_up'
    fill_in "Username", with: "user1"
    fill_in "Email", with: "user1@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit movie_path(movie)
    fill_in "Your rating", with: "4"
    click_button "Submit Rating"
    click_link "Logout"

    visit '/sign_up'
    fill_in "Username", with: "user2"
    fill_in "Email", with: "user2@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit movie_path(movie)
    fill_in "Your rating", with: "5"
    click_button "Submit Rating"

    expect(page).to have_content("4.5 stars")
  end

  scenario "Viewing a movie trailer" do
    movie.update!(trailer_url: "https://www.youtube.com/watch?v=0vS0E9bBSL0")
    visit movie_path(movie)

    click_button "Watch Trailer"

    expect(page).to have_css("iframe")
  end
end
