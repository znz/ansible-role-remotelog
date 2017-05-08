# Ansible role for syslog from remote

Allow to receive syslog from remote hosts.

## Requirements

- Debian
- Ubuntu

## Role Variables

- `remotelog_directory`: Directory for log files.
- `remotelog_basename`: Log file name pattern. See rsyslog documents for more information.

## Dependencies

None.

## Example Playbook

Example:

    - hosts: servers
      become: yes
      roles:
         - { role: znz.remotelog, remotelog_basename: "%$year%%$month%%$day%_%fromhost-ip%.log" }

## License

MIT License
