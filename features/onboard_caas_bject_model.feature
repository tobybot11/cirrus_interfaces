Feature: Automating creation of onboard user object model
  In order to use CaaS
  As an onboard user
  I want an object hierarchy created so that I can create Virtual Machines.

  Background:
    Given an onboard user session

  Scenario: Onboard user cloud object exists
    Then a cloud object shall exist with the following attributes
     | attribute   | value                                                        |
     | uri         | /accounts/420/clouds/293                                     |
     | description | Created by OnboardingService on 2010-02-17T17:59:53.59-05:00 |
     | name        | cloud-293                                                    |
   And one vdc with URI
     | attribute   | value                                                        |
     | vdc-276     | /accounts/420/clouds/293/vdcs/276                            |

   Scenario: Onboard user vdc object exists
    Then a vdc object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276                            |
     | vmtemplates_uri | /vmtemplates                                                 |
     | location_uri    | /locations/8                                                 |
     | description     | Created by OnboardingService on 2010-02-17T17:59:53.66-05:00 |
     | name            | vdc-276                                                      |
     | root_cluster    | *                                                            |
     | volumes         | *                                                            |
    And the root_cluster shall have URI    
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276/clusters/267               |
    And there will be one volume with URI
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276/volumes/151                |

   
   Scenario: Onboard user cluster object exists
    Then a cluster object shall exist with the following attributes
     | attribute       | value                                                    |
     | uri             | /accounts/420/clouds/293/vdcs/276/clusters/267           |
     | parent_uri      | /accounts/420/clouds/293/vdcs/276                        |
     | description     | Root Cluster                                             |
     | name            | cluster-267                                              |
     | controllers     | *                                                        |
     | vnets           | *                                                        |
    And two controllers with URIs
     | attribute       | value                                                    |
     | stop            | /accounts/420/clouds/293/vdcs/276/clusters/267/stop      |
     | start           | /accounts/420/clouds/293/vdcs/276/clusters/267/start     |
    And two vnets with URIs   
     | attribute       | value                                                    |
     | 0               | /accounts/420/clouds/293/vdcs/276/clusters/267/vnets/273 |
     | 1               | /accounts/420/clouds/293/vdcs/276/clusters/267/vnets/274 |

   Scenario: Onboard user volume object exists
    Then a volume object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276/volumes/151                |
     | vdc_uri         | /accounts/420/clouds/293/vdcs/276                            |
     | description     | Created by OnboardingService on 2010-02-17T17:59:54.94-05:00 |
     | name            | volume-151                                                   |
     | webdav          | nfs://172.16.90.2:/export/SUNNFSL16                          |
     | tags            | ["/accounts/420/clouds/293/vdcs/276/clusters/267/vnets/274"] |

   Scenario: Onboard user vnet objects exists
    Then two vnets shall exist
    And the first vnet shall have the following attributes 
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276/clusters/267/vnets/273     |
     | description     | Created by OnboardingService on 2010-02-17T17:59:54.50-05:00 |
     | name            | vnet-267                                                     |
     | tags            | ["217"]                                                      |
    And the second vnet shall have the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/420/clouds/293/vdcs/276/clusters/267/vnets/274     |
     | description     | Created by OnboardingService on2010-02-17T17:59:54.72-05:00  |
     | name            | vnet-267                                                     |
     | tags            |  ["390"]                                                     |
 