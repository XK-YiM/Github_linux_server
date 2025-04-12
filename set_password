#!/bin/bash

# 设置主机名为 root
sudo hostnamectl set-hostname root

# 更新 /etc/hosts 文件中的主机名
sudo sed -i "s/127.0.1.1.*/127.0.1.1\troot/g" /etc/hosts

# 设置当前用户密码为 admin123456（非交互式）
echo "当前用户密码已设置为 admin123456"
echo "admin123456" | sudo passwd --stdin $(whoami)

# 设置 root 用户密码为 admin123456
echo "root 用户密码已设置为 admin123456"
echo "admin123456" | sudo passwd --stdin root

# 输出提示信息
echo "主机名和密码已修改！重启后生效。"
echo "重启命令：sudo reboot"
