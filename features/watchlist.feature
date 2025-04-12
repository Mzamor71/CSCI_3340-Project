Feature: Watchlist Features

  Scenario: Adding a movie to the watchlist
    Given I am logged in as "user1"
    And I navigate to the movie "The Prestige"
    When I click the "Add to Watchlist" button in watchlist
    Then the movie should be added to my watchlist

  Scenario: Removing a movie from the watchlist
    Given I have "The Prestige" in my watchlist
    When I click the "Remove from Watchlist" button
    Then the movie should be removed from my watchlist