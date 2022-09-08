# !/bin/bash
# Run ansible playbook with interactive password entry.
ansible-playbook --ask-become-pass -i local_inventory.ini local_playbook.yml
