#!/bin/bash

# 启用SSH服务脚本
# 保存为 enable_ssh.sh 后执行：chmod +x enable_ssh.sh && sudo ./enable_ssh.sh

# 检查root权限
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用sudo或以root权限运行此脚本"
    exit 1
fi

# 更新软件包列表
echo "正在更新软件包列表..."
apt update -qq

# 安装OpenSSH服务
if ! dpkg -l | grep -q openssh-server; then
    echo "正在安装openssh-server..."
    apt install -y openssh-server > /dev/null
else
    echo "openssh-server 已安装"
fi

# 启用并启动SSH服务
echo "正在启动SSH服务..."
systemctl enable --now ssh > /dev/null 2>&1

# 防火墙配置
if command -v ufw &> /dev/null; then
    if ufw status | grep -qw active; then
        echo "配置UFW防火墙允许SSH连接..."
        ufw allow ssh > /dev/null
        ufw reload
    fi
else
    echo "提示：未安装UFW，如需防火墙配置请手动设置"
fi

# 验证服务状态
echo ""
echo "服务状态："
systemctl status ssh --no-pager | grep -E "Active:|Loaded:"

# 显示连接信息
echo ""
echo "SSH服务已启用，可通过以下地址连接："
echo "IP地址: $(hostname -I | cut -d' ' -f1)"
echo "端口: 22"
