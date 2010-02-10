Feature: Automating creation of onboard user object model
  In order to use CaaS
  As an onboard user
  I want an object hierarchy created so that I can create Virtual Machines.

  Scenario: Onboard user cloud object exists
    Given an onboard user session
    Then a cloud object shall exist with the following attributes
    | attribute   | value                |
    | uri         | /accounts/*/clouds/* |
    | description | *                    |
    | name        | *                    |
    | vdcs        | *                    |

   Scenario: Onboard user vdc object exists
    Given an onboard user session
    Then a vdc object shall exist with the following attributes
    | attribute       | value                       |
    | uri             | /accounts/*/clouds/*/vdcs/* |
    | vmtemplates_uri | /vmtemplates                |
    | location_uri    | /locations/*                |
    | description     | *                           |
    | name            | *                           |
    | vdcs            | *                           |
    | tags            | *                           |
    | root_cluster    | *                           |
    | volumes         | *                           |
   
   Scenario: Onboard user cluster object exists
    Given an onboard user session
    Then a cluster object shall exist with the following attributes
    | attribute       | value                                  |
    | uri             | /accounts/*/clouds/*/vdcs/*/clusters/* |
    | parent_uri      | /accounts/*/clouds/*/vdcs/*            |
    | description     | *                                      |
    | name            | *                                      |
    | vnets           | *                                      |
    | vms             | *                                      |
    | controllers     | *                                      |
