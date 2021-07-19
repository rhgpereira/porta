Feature: Service Usage Rules
  In order to configure my Product API
  As a provider
  I want to set my API usage rules

  Background:
    Given a provider "foo.3scale.localhost"
    And a default service of provider "foo.3scale.localhost" has name "My API"
    And current domain is the admin domain of provider "foo.3scale.localhost"
    And I log in as provider "foo.3scale.localhost"

  Scenario: Service v2
    Given provider "foo.3scale.localhost" uses backend v2 in his default service
    And I go to the service "My API" usage rules page
    Then I should see "Developers can manage Keys"
    And I should see "Require at least 1 application key"
    But I should not see "Allow developers to regenerate client secret"

  Scenario: Service Oauth
    Given provider "foo.3scale.localhost" uses backend oauth in his default service
    And I go to the service "My API" usage rules page
    Then I should see "Allow developers to regenerate client secret"
    But I should not see "Developers can manage Keys"
    And I should not see "Require at least 1 application key"
