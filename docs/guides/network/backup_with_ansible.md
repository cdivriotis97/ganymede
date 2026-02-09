# Backup Nexus & Cisco configuration with Ansible

**Requirements :**

* **cisco-nxos** collection
* **ansible-netcommon** collection
* **cisco-ios** collection

This outlines the primary commands to back up the devices; however, the Ansible tasks for local data persistence and file generation are omitted.

### Cisco NEXUS
To backup Nexus : 
```ini
	- name: get running-config
      nxos_command:
        commands: show running | exclude ^!Time
      register: running_cfg

    - name: get startup-config
      nxos_command:
        commands: show startup | exclude ^!Time
      register: startup_cfg
```

### Cisco IOS
To backup IOS :
```ini
    - name: get running-config
      ios_command:
        commands: show running | exclude ntp clock-period
      register: running_cfg
      ignore_errors: true

    - name: get startup-config
      ios_command:
        commands: show startup | exclude ntp clock-period
      register: startup_cfg
      ignore_errors: true
```

### Ansible Network Connection
!!! tip

    For network devices, you will need specific connection variables to access the devices : [https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/network_cli_connection.html](https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/network_cli_connection.html).
  

```ini
[all:vars]
ansible_connection=network_cli
ansible_user=changeme
ansible_password= "useVault"
ansible_become=yes
ansible_become_method=enable
ansible_become_password="useVault"
ansible_network_cli_ssh_type=paramiko

[nxos:vars]
ansible_network_os=nxos

[ios:vars]
ansible_network_os=ios
```
