# Hosts config

I have several hosts, but only a few are currently in use:

Name         | Description
------------ | -----------
`io`         | Lenovo laptop, main machine
`kiiro`      | Previous main machine, retired and rarely used server now
`arm-server` | Oracle ARM server
`homesv`     | Old Dell laptop used as a local homeserver
`tosh`       | Old Toshiba laptop, no longer used

All the hosts have a shared config in `modules/minimal.nix`.
Host specific configs are stored inside the specific host dir.

All hosts are deployed using `deploy-rs`.
