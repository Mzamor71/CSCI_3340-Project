Feature: Comment

As "name" user
I want to comment on a rating
So that other people can see my opinion

# Comment Features
  Scenario: Leaving a comment on someone else's rating
    Given I am logged in as "Charlie"
    And I navigate to the movie "Inception"
    And I see "Alice" rated it 5 stars
    When I leave a comment "Great rating! I totally agree."
    Then my comment should appear under "Alice's" rating

  Scenario: Liking a comment
    Given I am logged in as "user2"
    And I see a comment by "Charlie" on "Alice's" rating
    When I click the "Like" button for the comment
    Then the like count for "Charlie's" comment should increase by 1