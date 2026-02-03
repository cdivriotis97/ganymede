Collections needed :
- cisco-nxos
- ansible-netcommon
- cisco-ios


to backup nexus :    
	- name: get running-config
      nxos_command:
        commands: show running | exclude ^!Time
      register: running_cfg

    - name: get startup-config
      nxos_command:
        commands: show startup | exclude ^!Time
      register: startup_cfg


to backup ios :
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


[all:vars]
# START ansible.netcommon.network_cli connection
# All these variable are for ansible.netcommon.network_cli connection
# https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/network_cli_connection.html
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
