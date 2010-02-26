Feature: Managment of Virtual Machines
  In order to manage Virtual Machines
  As an authenticated user
  I need to be able to create/update/delete Virtual Machines, manage run state of Virtual Machines and attach storage 
  Volumes to Virtual Machines.

  Background:
    Given an authenticated onboard user session

  Scenario: Create and Delete a Virtual Machine object and verify attributes
    Given the following Virtual Machine Configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then create a Virtual Machine which shall have the following attributes
     | attribute         | value                                                        |
     | name              | Cuke Test VM                                                 |
     | uri               | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*         |
     | description       | Cucumber test VM                                             |
     | hostname          | *                                                            |
     | os                | Red Hat Enterprise Linux 5 (64-bit)                          |
     | run_state         | STARTED                                                      |
     | memory            | 4096MB of memory                                             |
     | data_disk         | 104857600                                                    |
     | cpu               | 1 virtual CPU(s)                                             |
     | cluster_uri       | /accounts/443/clouds/307/vdcs/290/clusters/281               |
     | from_template_uri | /vmtemplates/25                                              |
     | controllers       | *                                                            |
     | interfaces        | *                                                            |
    And three controllers with the following URIs 
     | attribute       | value                                                          |
     | stop            | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/stop      |
     | reboot          | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/reboot    |
     | hibernate       | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/hibernate |
    And two vnets with URIs
     | index           | value                                                          |
     | 0               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301       |
     | 1               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/302       |
    And the following interface attributes
     | attribute       | value                                                          |
     | mac_address     | not_available                                                  |
     | nic             | PCNet32 ethernet adapter on \"Internal\" network               |
     | public_address  | *                                                              |
     | ip_address      | *                                                              |
     | vnet_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301       |
    And delete the virtual machine
   
  Scenario: Shutdown Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED with attributes
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then the Virtual Machine shall have the following attributes with values 
     | attribute         | value    |
     | os                | RHEL5    |
     | run_state         | STARTED  |
     | memory            | 2048     |
     | cpu               | 1800     |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And there should be one available controller
     | index           | value                                                          |
     | start           | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/start     |

  Scenario: Restart STOPPED Virtual Machine
    Given a Virtual Machine that has been verified stopped and is in run_state STOPPED with attributes
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then if it is restarted it will have the following run_state
     | attribute  | value    |
     | run_state  | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Reboot Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED with attributes
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then if it is rebooted it will have the following run_state
     | attribute | value    |
     | run_state | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Delete a stopped Virtual Machine
    Given a Virtual Machine that has been verified stopped and is in run_state STOPPED with attributes
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then if it is deleted it should not be returned in a query for Virtual Machines

