Feature: Start CaaS Session
  In order to use CaaS
  As administrator or user
  I want start a session.

  Scenario: An admin provides valid authentication credentials
    Given a valid "admin" user ID and a valid password
    Then a valid CaaS "admin" session can be created with the following attributes
    | attribute      | value |
    | authentication |   *   |
    

  Scenario: A user provides valid authentication credentials
    Given a valid "user" user ID and a valid password
    Then a valid CaaS "user" session can be created with the following attributes
    | attribute       | value                 |
    | authentication  |   *                   |
    | account_uri     | /accounts/420         |
    | clouds_uri      | /accounts/420/clouds  |
    | locations_uri   | /locations            | 
    | vmtemplates_uri | /vmtemplates          |
    | onboard_uri     | /accounts/420/onboard |

