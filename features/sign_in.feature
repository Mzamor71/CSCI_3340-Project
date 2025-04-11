Feature: User authentication
  As a user
  I want to sign up, sign in, and log out
  So that I can access and protect my account

Scenario: Signing up for an account
  Given I am on the sign-up page
  When I enter a valid username, email, and password
  And I submit the form
  Then my account should be created
  And I should be redirected to the homepage

Scenario: Signing in with valid credentials
  Given I have an existing account
  And I am on the login page
  When I enter my correct email and password
  And I submit the form
  Then I should be logged in
  And I should see my username displayed on the homepage

Scenario: Logging out
  Given I am logged in
  When I click the logout button
  Then I should be logged out
  And I should be redirected to the login page