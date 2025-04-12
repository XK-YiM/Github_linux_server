# Github_linux_server

## 设置新的密码
因为不确定codespaces的root密码
所以我们先设置密码
在main创建好codespaces后
先运行 sudo su 切换到root权限
然后运行chmod +x set_password.sh
为set_password.sh提升权限
然后运行sudo ./set_password.sh
**这个会将主机名设置为：root**
**密码设置为：admin123456**

## 运行ssh
运行 sudo chmod +x enable_ssh.sh
提升权限
然后运行 sudo ./enable_ssh.sh


## 通过ssh连接
**ssh your_username@服务器IP地址**
