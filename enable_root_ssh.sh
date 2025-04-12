#!/bin/bash

# 自动启用SSH密码登录root脚本
# 保存为 enable_root_ssh.sh 后执行：chmod +x enable_root_ssh.sh && sudo ./enable_root_ssh.sh

# 检查root权限
if [ "$(id -u)" -ne 0 ]; then
    echo "必须使用sudo或以root权限运行此脚本"
    exit 1
fi

# 预定义配置
ROOT_PASSWORD="Githubpass20250412!"  # 可在此修改密码

# 警告提示
echo "████████████████████████████████████████████████████████████
  安全警告：此配置将允许root密码登录，存在重大安全风险！
  仅建议在以下场景使用：
  1. 临时测试环境
  2. 受信任的内网环境
  3. 配合防火墙IP白名单使用
████████████████████████████████████████████████████████████"
sleep 3

# 安装必要组件
echo "正在更新软件包列表..."
apt update -qq

if ! dpkg -l | grep -q openssh-server; then
    echo "安装openssh-server..."
    apt install -y openssh-server > /dev/null
fi

# 设置root密码
echo "正在设置root密码..."
echo "root:$ROOT_PASSWORD" | chpasswd
if [ $? -eq 0 ]; then
    echo "√ 密码设置成功"
else
    echo "× 密码设置失败，请手动检查！"
    exit 1
fi

# 修改SSH配置
echo "配置SSH参数..."
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 重启服务
systemctl restart ssh
echo "服务已重启"

# 防火墙配置
if command -v ufw &> /dev/null; then
    if ufw status | grep -qw active; then
        echo "配置UFW放行22端口..."
        ufw allow 22/tcp > /dev/null
        ufw reload
    fi
fi

# 验证输出
echo ""
echo "████████ 连接信息 ██████████"
echo "用户名：root"
echo "密码：$ROOT_PASSWORD"
echo "IP地址：$(hostname -I | cut -d' ' -f1)"
echo "端口：22"
echo "测试命令：ssh root@$(hostname -I | cut -d' ' -f1)"

echo ""
echo "████████ 网络信息检测 ██████████"
echo "内网IP: $(hostname -I | cut -d' ' -f1)"
echo "公网IPv4: $(curl -4 -s ifconfig.me)"
echo "公网IPv6: $(curl -6 -s ifconfig.me || echo '不支持')"
echo "路由出口: $(ip route get 1.1.1.1 | awk '{print $7}')"
echo ""
echo "████████ 安全建议 ██████████"
echo "1. 使用后请立即执行以下命令禁用root登录："
echo "   sed -i 's/^PermitRootLogin.*/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && systemctl restart ssh"
echo "2. 推荐后续操作："
echo "   - 修改SSH端口"
echo "   - 禁用密码登录"
echo "   - 配置fail2ban防护"
echo "   - 设置普通用户+sudo权限"
