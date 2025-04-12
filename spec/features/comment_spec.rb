require 'rails_helper'

RSpec.feature "Comment Feature", type: :feature do
  let!(:genre) { Genre.create!(name: "Sci-Fi") }
  let!(:movie) { Movie.create!(title: "Inception", genres: [genre]) }

  before(:each) do
    # Sign up Alice
    visit new_user_registration_path
    fill_in "Username", with: "Alice"
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit movie_path(movie)
    choose "rating_stars_4"
    click_button "Submit Rating"
    click_button "Logout"

    # Sign up Charlie
    visit new_user_registration_path
    fill_in "Username", with: "Charlie"
    fill_in "Email", with: "charlie@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
  end

  scenario "Charlie leaves a comment on Alice's rating" do
    visit movie_path(movie)
    fill_in "Your Comment", with: "Great review, Alice!"
    click_button "Submit Comment"

    expect(page).to have_content("Great review, Alice!")
    expect(page).to have_content("Charlie")
  end

  scenario "Another user likes Charlie's comment" do
    visit movie_path(movie)
    fill_in "Your Comment", with: "Nice one!"
    click_button "Submit Comment"
    click_button "Logout"

    # Sign up User2
    visit new_user_registration_path
    fill_in "Username", with: "User2"
    fill_in "Email", with: "user2@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit movie_path(movie)

    within('.comments-section') do
      click_button "Like"
    end

    expect(page).to have_content("1 like")
  end
end