#!/bin/bash
#Installing Docker

#requierements
sudo dnf check-update
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git firewalld bind bind-utils

# start docker service
sudo systemctl start docker
sudo systemctl status docker

# config docker service
sudo usermod -aG docker $(whoami)
sudo chmod 666 /var/run/docker.sock

# config for wireguard
sudo modprobe ip_tables
sudo echo 'ip_tables' /etc/modules >>sudo

# run wireguard container
git clone https://github.com/DanielDucuara2018/video_streaming.git /opt/video_streaming
docker compose -f /opt/video_streaming/docker-compose.wireguard.yml up -d

# config and run DNS
sudo hostnamectl set-hostname ns1.streaming.home

sudo cat /etc/hosts <<EOF >>sudo
127.0.0.1   ns1.streaming.admin     ns1
EOF

sudo hostname -f

sudo cat /etc/sysconfig/named <<EOF >>sudo
OPTIONS="-4"
EOF

sudo systemctl start named
sudo systemctl enable named
sudo systemctl is-enabled named
sudo systemctl status named

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --list-services

sudo cat /etc/named.conf <<EOF >sudo
acl "trusted" {
  localhost;    # ns1 - or you can use localhost for ns1
  192.168.1.0/24;  # trusted networks
  192.168.2.0/24;  # trusted networks
};

options {
  listen-on port 53 { localhost; };

  // listen-on-v6 port 53 { ::1; };
  
  directory       "/var/named";
  dump-file       "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  secroots-file   "/var/named/data/named.secroots";
  recursing-file  "/var/named/data/named.recursing";
  
  allow-query     { localhost; trusted; };

  recursion yes;
  allow-recursion { trusted; };
  allow-transfer { localhost; };

  forwarders {
    8.8.8.8;
    1.1.1.1;
  };
};

include "/etc/named/zones.streaming.home";
EOF

sudo tee /etc/named/zones.streaming.home >/dev/null <<EOF
zone "streaming.home" {
  type master;
  file "db.streaming.home"; # zone file path
  allow-transfer { none; }; # ns2 IP address - secondary DNS
};

zone "1.168.192.in-addr.arpa" {
  type master;
  file "db.192.168.1";  # subnet 192.168.1.0/24
  allow-transfer { none; };  # ns2 private IP address - secondary DNS
};

zone "2.168.192.in-addr.arpa" {
  type master;
  file "db.192.168.2";  # subnet 192.168.2.0/24
  allow-transfer { none; };  # ns2 private IP address - secondary DNS
};
EOF

sudo tee /var/named/db.streaming.home >/dev/null <<EOF
;
; BIND data file for the local loopback interface
;
; sudo nano /var/named/db.streaming.home
$TTL    604800
@	IN	SOA     ns1.streaming.home. admin.streaming.home. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )	; Negative Cache TTL
;

; NS records for name servers
    IN      NS      ns1.streaming.home.

; A records for name servers
ns1.streaming.home.          IN      A       192.168.1.100

; A records for domain names
streaming.home.              IN      A      192.168.2.100
*.streaming.home.            IN      A      192.168.2.100
EOF

sudo tee /var/named/db.192.168.1 >/dev/null <<EOF
;
; BIND reverse data file for the local loopback interface
;
; sudo nano /var/named/db.192.168.1
$TTL    604800
@       IN      SOA     ns1.streaming.home. admin.streaming.home. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

; name servers - NS records
      IN      NS      ns1.streaming.home.

; PTR Records
100   IN      PTR     ns1.streaming.home.    ; 192.168.1.100
EOF

sudo tee /var/named/db.192.168.2 >/dev/null <<EOF
;
; BIND reverse data file for the local loopback interface
;
; sudo nano /var/named/db.192.168.2
$TTL    604800
@       IN      SOA     ns1.streaming.home. admin.streaming.home. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

; name servers - NS records
      IN      NS      ns1.streaming.home.

; PTR Records
100   IN      PTR     streaming.home.       ; 192.168.2.100
EOF

sudo chown -R named: /var/named/{db.streaming.home,db.192.168.1,db.192.168.2}

sudo unlink /etc/resolv.conf
sudo cat /etc/resolv.conf <<EOF >sudo
nameserver 127.0.0.1
nameserver 192.168.1.1
search streaming.local
EOF

sudo systemctl restart named
sudo systemctl status named

docker compose restart wireguard
