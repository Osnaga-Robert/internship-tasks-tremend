# Configurate the Linux environment

## Install the necessary packages

- apt update
- apt install dnsutils -y -> for dig command
- apt-get install -y iputils-ping -> for ping command
- apt install vim -y -> select the continent and the country you are from (for vim editor)
- apt-get install netcat-traditional (for nc command)
- apt install curl -y -> for curl command

## 1. Public IP for cloudfare.com

- dig cloudfare.com +short
- as a result, I got 2 IP addresses:
  - 104.16.133.229
  - 104.16.132.229

There are 2 IP addresses because cloudfare.com uses an anycast IP network\
that allows multiple seves to share the same IP address. So when I log in\
to cloudfare.com, I will be redirected to the nearest server.

## 2. Map IP addrress 8.8.8.8 to hostname google-dns

- vim /etc/hosts
- edit the file by pressing i
- Add the following line to the file:
- 8.8.8.8     google-dns
- exit and save the file :wq

## 3. Check if the DNS Port is Open for google-dns

- first check the DNS port number which is 53 (DNS basic port number)
- use nc -zv google-dns 53 to check if the port is open
  - z flag: scans for open ports
  - v flag: verbose, used for displaying more information

## 4. Modify the System to Use Google's public DNS

### 4.1 Change the nameserver to 8.8.8.8 instead of the default local configuration

- vim /etc/resolv.conf
- edit the file by pressing i
- change the nameserver to 8.8.8.8
- exit and save the file :wq
- check the modification by using cat /etc/resolv.conf

### 4.2 Perform another public IP lookup for cloudflare.com and compare the results

- dig cloudfare.com +short
- as a result, I got 2 IP addresses:
  - 188.114.96.3
  - 188.114.97.3

The IP addresses are different from the previous lookup because I changed\
the DNS server to google's public DNS so now the DNS server from google\
is used to resolve the IP addresses.

## 5. Install and verify that Nginx service is running 

- apt install nginx -y
- service nginx start -> to start the service
- service nginx status -> to check the status of the service (active)

## 6. Find the Listening Port for Nginx

- cat /etc/nginx/sites-enabled/default | grep listen -> to find the listening port
- as a result, the listening port is 80
- ss -tuln | grep 80 -> to check if the port is open

## Bonus

### 1. Change the Nginx Listening port to 8080

- vim /etc/nginx/sites-enabled/default
- edit the file by pressing i
- change the listening port to 8080
- exit and save the file :wq
- service nginx restart -> to restart the service
- ss -tuln | grep 8080 -> to check if the port is open

### 2. Modify the default HTML page

- check the default HTML page using curl http://localhost:8080
- vim /var/www/html/index.nginx-debian.html
- edit the file by pressing i
- change the title of the file
- exit and save the file :wq
- service nginx restart -> to restart the service
- open the browser and go to the IP address of the server with the port number
- use curl http://localhost:8080 to check the modification

# Conclusion

For first time working with a linux container, I can say that is very primitive\
in terms of security and configuration. I had to install some packages to be able\
that in many vm's are already installed. There is not even de man command to get\
because the container needed to be so small. I had to use the internet to find\
the commands that I needed to install the packages and some commands for nginx.\
I founded [this](https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview) tutorial for my use.
To my surprise, when I tested everything, the IP's from dig command were the same even if\
I changed the DNS server to google's public DNS.
