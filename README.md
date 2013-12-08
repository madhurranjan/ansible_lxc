ansible_lxc
===========

ansible_lxc - plugin to create lxc using ansible . Initial development

Test it as follows:

ansible/hacking/test-module -m tests/lxc.rb -a "name=hello"

If you want to include template(by default uses sshd template)
ansible/hacking/test-module -m tests/lxc.rb -a "name=hello template=ubuntu"

If you want to include config_file(by default uses standard file specified in lxc-create)
ansible/hacking/test-module -m tests/lxc.rb -a "name=hello template=ubuntu config_file=<path to config file>"
