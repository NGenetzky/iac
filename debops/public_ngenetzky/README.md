
# debops public ngenetzky

## bugs

### root profile

```
fatal: [grml]: FAILED! => changed=false 
  msg: Destination /root/.profile does not exist !
  rc: 257
```

### etc hosts

```
TASK [core : Save local facts] *********************************************************************************************************************************************************************************
failed: [grml] (item=core) => changed=false 
  ansible_loop_var: item
  item: core
  msg: 'AnsibleUndefinedVariable: ''ansible.utils.unsafe_proxy.AnsibleUnsafeText object'' has no attribute ''items'''
ok: [grml] => (item=tags)
```
