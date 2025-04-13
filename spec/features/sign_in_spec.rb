require 'rails_helper'

RSpec.feature "SignIn Feature", type: :feature do
  background do
    visit '/sign_up'
    fill_in "Username", with: "existinguser"
    fill_in "Email", with: "existing@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
    click_link "Logout"
  end

  scenario "Signing up for an account" do
    visit '/sign_up'
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Welcome")
  end

  scenario "Signing in with valid credentials" do
    visit '/login'
    fill_in "Email", with: "existing@example.com"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content("existinguser")
  end

  scenario "Logging out" do
    visit '/login'
    fill_in "Email", with: "existing@example.com"
    fill_in "Password", with: "password"
    click_button "Login"
    click_link_or_button "Logout"

    expect(page).to have_content("Signed out")
  end
end
