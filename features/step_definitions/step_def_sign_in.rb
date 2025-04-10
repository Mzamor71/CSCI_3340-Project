# Scenario: Signing up for an account
Given("I am on the sign-up page") do
  visit new_user_registration_path
end

When("I enter a valid username, email, and password") do
  fill_in "Username", with: "testuser"
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password123"
  fill_in "Password confirmation", with: "password123"
end

When("I submit the form") do
  click_button "Sign up"
end

Then("my account should be created") do
  expect(User.find_by(email: "test@example.com")).to be_present
end

Then("I should be redirected to the homepage") do
  expect(current_path).to eq root_path
end

# Scenario: Signing in with valid credentials
Given("I have an existing account") do
  User.create!(
    username: "existinguser",
    email: "existing@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
end

Given("I am on the login page") do
  visit new_user_session_path
end

When("I enter my correct email and password") do
  fill_in "Email", with: "existing@example.com"
  fill_in "Password", with: "password123"
end

Then("I should be logged in") do
  expect(page).to have_content("Signed in successfully")
end

Then("I should see my username displayed on the homepage") do
  expect(page).to have_content("existinguser")
end

# Scenario: Logging out
Given("I am logged in") do
  step "I have an existing account"
  step "I am on the login page"
  step "I enter my correct email and password"
  step "I submit the form"
end

When("I click the {string} button") do |button_name|
  click_link_or_button button_name
end

Then("I should be logged out") do
  expect(page).to have_content("Signed out successfully")
end

