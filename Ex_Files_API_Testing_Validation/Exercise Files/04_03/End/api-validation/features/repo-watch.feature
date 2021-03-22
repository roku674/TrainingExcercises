Feature: This is an important repository
  Scenario: I want to watch my repository
    Given I am an authenticated user
      And I have a repository called "monkey"
    When  I watch the "monkey" repository
    Then  The "monkey" repository will list me as a watcher
      And I delete the repository called "monkey"