Feature: Automating creation of onboard user object model
  In order to use CaaS
  As an onboard user
  I want an object hierarchy created so that I can create Virtual Machines.

  Background:
    Given an onboard user session

  Scenario: Onboard user cloud object exists
    Then a cloud object shall exist with the following attributes
    | attribute   | value                |
    | uri         | /accounts/*/clouds/* |
    | description | *                    |
    | name        | *                    |
    | vdcs        | *                    |

   Scenario: Onboard user vdc object exists
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
    Then a cluster object shall exist with the following attributes
    | attribute       | value                                  |
    | uri             | /accounts/*/clouds/*/vdcs/*/clusters/* |
    | parent_uri      | /accounts/*/clouds/*/vdcs/*            |
    | description     | *                                      |
    | name            | *                                      |
    | vnets           | *                                      |
    | vms             | *                                      |
    | controllers     | *                                      |

   Scenario: Onboard user volume object exists
    Then a volume object shall exist with the following attributes
    | attribute       | value                                  |
    | uri             | /accounts/*/clouds/*/vdcs/*/volumes/*  |
    | vdc_uri         | /accounts/*/clouds/*/vdcs/*            |
    | description     | *                                      |
    | name            | *                                      |
    | webdav          | nfs://172.16.45.2:/export/SUNNFSL9     |
    | tags            | *                                      |

   Scenario: Onboard user vnet objects exists
    Then two vnets shall exist
    And the first shall have the following attributes 
    | attribute       | value                                  |
    | uri             |   |
    | cluster_uri     | /accounts/*/clouds/*/vdcs/*            |
    | description     | *                                      |
    | name            | *                                      |
    | tags            | *                                      |
    And the second shall have the following attributes
    | attribute       | value                                  |
    | uri             |   |
    | cluster_uri     | /accounts/*/clouds/*/vdcs/*            |
    | description     | *                                      |
    | name            | *                                      |
    | tags            | *                                      |
 