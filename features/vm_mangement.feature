Feature: Managment of Virtual Machines
  In order to manage Virtual Machines
  As an authenticated user
  I need to be able to create/update/delete Virtual Machines, manage run state of Virtual Machines and attach storage 
  Volumes to Virtual Machines.

  Background:
    Given an authenticated onboard user session

  Scenario: Create a Virtual Machine object and verify attributes
    Given the following Virtual Machine Configuration
     | attribute   | value                                                        |
     | name        | Cuke VM                                                      |
     | description | Cucumber test VM                                             |
     | vmtemplate  | RHEL5-Small                                                  |
    Then create a Virtual Machine which shall have the following attributes
     | attribute         | value                                                        |
     | name              | Cuke VM                                                      |
     | uri               | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*         |
     | description       | Cucumber test VM                                             |
     | os                | RHEL                                                         |
     | updated           | true                                                         |
     | last_boot         | *                                                            |
     | run_state         | STARTED                                                      |
     | memory            | 2048                                                         |
     | temp_disk         | 10                                                           |
     | boot_disk         | 10                                                           |
     | data_disk         | 10                                                           |
     | cpu               | 1800                                                         |
     | attach_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/attach  |
     | backup_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/back_up |
     | detach_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/detach  |
     | cluster_uri       | /accounts/443/clouds/307/vdcs/290/clusters/281               |
     | controllers       | *                                                            |
     | from_template_uri | *                                                            |
     | from_vm_uri       | *                                                            |
     | params            | *                                                            |
     | tags              | *                                                            |
     | interfaces        | *                                                            |
     | vnets             | *                                                            |
    And two controllers with the following URIs 
     | attribute       | value                                                          |
     | stop            | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/stop      |
     | reboot          | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/reboot    |
    And two vnets with URIs
     | index           | value                                                          |
     | 0               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301       |
     | 1               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/302       |
    And the following interface attributes
     | attribute       | value                                                          |
     | ip_address      | *                                                              |
     | mac_address     | *                                                              |
     | nic             | *                                                              |
     | public_address  | *                                                              |
     | vnet_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301       |
   
  Scenario: Verify STARTED runs_state for RHEL5-Small Virtual Machine
    Given a Virtual Machine created with the following configuration
     | attribute   | value            |
     | name        | Cuke VM          |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |    
    Then the Virtual Machine shall have the following attributes with values 
     | attribute  | value   |
     | os         | RHEL5   |
     | run_state  | STARTED |
     | memory     | 2048    |
     | cpu        | 1800    |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Shutdown Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED with attributes
     | attribute   | value             |
     | name        | Cuke VM           |
     | description | Cucumber test VM  |
     | vmtemplate  | RHEL5-Small       |
    Then the Virtual Machine shall have the following attributes with values 
     | attribute         | value    |
     | os                | RHEL5    |
     | run_state         | STARTED  |
     | memory            | 2048     |
     | cpu               | 1800     |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Shutdown Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED
    Then if it is stopped it will have the following run_state
     | attribute         | value    |
     | run_state         | STOPPED  |
    And it should not be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should not be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Restart STOPPED Virtual Machine
    Given a Virtual Machine that has been verified stopped and is in run_state STOPPED
    Then if it is restarted it will have the following run_state
     | attribute  | value    |
     | run_state  | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Reboot Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED
    Then if it is rebooted it will have the following run_state
     | attribute | value    |
     | run_state | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"

  Scenario: Delete a running Virtual Machine
    Given a Virtual Machine that has been verified running and is in run_state STARTED
    Then if it is deleted it should not be returned in a query for Virtual Machines
    And it not should be possible to log into the Virtual Machine through its network interface on its last known "public_address"
    And it not should be possible to log into the Virtual Machine through its network interface on its last known "ip_address"

  Scenario: Delete a stopped Virtual Machine
    Given a Virtual Machine that has been verified stopped and is in run_state STOPPED
    Then if it is deleted it should not be returned in a query for Virtual Machines

