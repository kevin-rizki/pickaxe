For every command, fill the password of each hosts.

Check hosts are available:
```
ansible -i hosts all -m ping -k
```

Run this respectively to install cluster:
```
ansible-playbook -i hosts initial.yaml -k

ansible-playbook -i hosts kube-dependencies.yaml -k

ansible-playbook -i hosts master.yaml -k

ansible-playbook -i hosts slaves.yaml -k
```
