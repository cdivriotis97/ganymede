# Backup Brocade FOS configuration & IBM configuration devices with Ansible

This outlines the primary commands to back up the devices; however, the Ansible tasks for local data persistence and file generation are omitted.

To backup Brocade FOS :
```ini
    - name: "Define context depending on brocade name"
      set_fact:
        contexts: "{{ [20, 40] if (inventory_hostname is search('brocade.*dc2')) else ([10, 30] if (inventory_hostname is search('brocade.*dc1')) else [1]) }}"
    - name: "Run switchshow on brocade"
      shell: "sshpass -p '{{ ansible_ssh_pass }}' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no {{ ansible_user }}@{{ inventory_hostname }} switchshow"
      register: running_switch_cfg
      delegate_to: localhost

    - name: "Run cfgshow on brocade with all contexts"
      shell: |
        sshpass -p '{{ ansible_ssh_pass }}' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no {{ ansible_user }}@{{ inventory_hostname }} << EOF
        setcontext {{ item }}
        cfgshow
        exit
        EOF
      register: running_zone_cfg
      loop: "{{ contexts }}"
      delegate_to: localhost
```

To backup IBM storage :
```ini
    - name: "Trigger the configuration backup (svcconfig backup)"
      shell: "sshpass -p '{{ ansible_ssh_pass }}' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no {{ ansible_user }}@{{ inventory_hostname }} 'svcconfig backup'"
      register: backup_output
      delegate_to: localhost

    - name: "Collect backup files from FlashSystem via SCP"
      shell: "sshpass -p '{{ ansible_ssh_pass }}' scp -o StrictHostKeyChecking=no {{ ansible_user }}@{{ inventory_hostname }}:{{ backup_svc }}/svc.config.backup.*  {{ backup_folder }}/{{ inventory_hostname }}/"
      register: scp_output
      delegate_to: localhost
```

https://www.ibm.com/docs/en/flashsystem-5x00?topic=STHGUJ/com.ibm.storwize.v5100.841.doc/svc_clustconfbackuptsk_1e4k69.htm

SANnav can create a daily backup. 
Do not forget to push this backup outside SANnav.
