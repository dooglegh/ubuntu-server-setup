#!/bin/bash
# Created by doogle@naver.com
# iwinv.kr - Ubuntu 22.04 서버 이미지 초기 설정용 스크립트

# Timezone 지정
echo "Timezone setup..."
# UTC
date
sudo timedatectl set-timezone Asia/Seoul
# Local Timezone
date

# 우분투 리눅스 초기 서버 업데이트
echo "Ubuntu update & ugrade..."
sudo apt update
sudo apt upgrade -y

echo "Install Docker engine..."
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Install certbot (https)..."
sudo snap install --classic certbot
echo "Install SSL... > sudo certbot --nginx"

echo "Add user (sudoer)..."
sudo adduser 사용자아이디
sudo touch /etc/sudoers.d/사용자아이디
sudo echo "사용자아이디 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/사용자아이디

echo "Clear firewall rules..."
sudo iptables -F

echo "Change ssh server settings (root login disabled, custom port no 8577) ..."
sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/#Port 22\nPort 8577/g" /etc/ssh/sshd_config

sudo apt install nginx mariadb-client php mc

# 추가 블록 스토리지 파티션 생성
# lsblk
# fdisk /dev/vdc
# n (엔터) (엔터) (엔터) w
# /sbin/mkfs.ext4 /dev/vdc1
# sudo mkdir /var/www
# mount /dev/vdc1 /var/www
# echo "/dev/vdc1 	/var/www	ext4	defaults	0 0" >> /etc/fstab

# 스왑파일 생성 및 스왑 실행...
# fallocate -l 8G /var/www/.swapfile
# mkswap /var/www/.swapfile
# chmod 0600 /var/www/.swapfile
# swapon /var/www/.swapfile
# echo "/var/www/.swapfile none swap sw 0 0" >> /etc/fstab

