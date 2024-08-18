#!/usr/bin/bash

cd root

echo "whoami..."
whoami

echo "pwd..."
pwd

echo "update logging configuration..."
sudo sh -c "echo '*.info;mail.none;authpriv.none;cron.none /dev/ttyS0' >> /etc/rsyslog.conf"
sudo systemctl restart rsyslog

# need this but commented out to speed things up, do not do this in production
echo "upgrading apt-get..."
sudo apt-get update && sudo apt-get dist-upgrade

echo "installing MariaDB..."
sudo apt-get install mysql -y
sudo apt-get install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl status mariadb
sudo systemctl enable mariadb

echo "creating mysql_secure_installation.txt..."
touch mysql_secure_installation.txt
cat << `EOF` >> mysql_secure_installation.txt

n
Y
comsc
comsc
Y
Y
Y
Y
Y
`EOF`

echo "running mysql_secure_installation..."
sudo mysql_secure_installation < mysql_secure_installation.txt

echo "change root password..."
sudo mysql -u root -pcomsc -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'comsc';"

echo "--------------------ls files-------------------"
ls
echo in directory: $PWD

# sudo apt update && sudo apt upgrade -y
sudo apt-get install wget -y
sudo apt-get install unzip -y
sudo apt-get install git -y

# needs to be in root account
echo "cd to root..."
ls
echo "whoami..."
whoami
# error: /var/lib/cloud/instance/scripts/part-001: line 60: cd: root: No such file or directory
#cd root

echo "installing gitlab server key..."
touch .ssh/known_hosts
ssh-keyscan git.cardiff.ac.uk >> .ssh/known_hosts
chmod 644 .ssh/known_hosts

echo "installing gitlab deployment key..."
echo "now needs to be in debian user directory"
cd /home/debian
touch wsa_keypair.key
cat << `EOF` >> wsa_keypair.key
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
`EOF`
chmod 400 wsa_keypair.key

echo "cloning repository..."
echo $PWD
ssh-agent bash -c 'ssh-add wsa_keypair.key; git clone git@git.cardiff.ac.uk:c23031770/wsa_volunteer_hub.git'

echo "whoami..."
whoami
echo "ls"
ls
cd wsa_volunteer_hub

echo "link to database..."
mysql -u root -pcomsc < src/main/resources/schema.sql


echo "installing Java 17..."
sudo apt update
sudo apt install openjdk-17-jdk -y
echo java --version

echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y npm
node -v
npm -v
 
echo "Installing maven..."
sudo apt-get install maven -y
mvn -v

echo "Link to Jenkins repository"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "install Jenkins"
sudo apt-get update
sudo apt-get install jenkins -y

echo "installing gitlab server key... has to be added to the jenkins user home (~) dir "
mkdir /var/lib/jenkins/.ssh
sudo touch /var/lib/jenkins/.ssh/known_hosts
sudo ssh-keyscan git.cardiff.ac.uk >> /var/lib/jenkins/.ssh/known_hosts
sudo chmod 644 /var/lib/jenkins/.ssh/known_hosts

sudo systemctl start jenkins

# echo "-----Change Jenkins port to 8083-----"
# # If you want jenkins on port 8083 so you can run your app on 8080 then change the default jenkins port.
# sudo systemctl stop jenkins
# sudo sed --i 's/JENKINS_PORT=8080/JENKINS_PORT=8083/g' /usr/lib/systemd/system/jenkins.service
# sudo systemctl daemon-reload
# sudo systemctl restart jenkins
# sudo systemctl status jenkins
# sudo systemctl enable jenkins
# 获取实例的外部IP地址
EXTERNAL_IP=$(openstack server show <WSAProjectBuild> -f value -c addresses | awk -F'=' '{print $2}')

# 如果获取不到外部IP，则使用默认的localhost
if [ -z "$EXTERNAL_IP" ]; then
    EXTERNAL_IP="localhost"
fi

# 打印获取的IP地址，便于调试
echo "Using external IP: $EXTERNAL_IP"
# build
#back-end
ls
./mvnw install
nohup ./mvnw spring-boot:run &
 
#front-end
cd front-end
npm install
# 设置 VITE_API_BASE_URL 环境变量并启动前端开发服务器
VITE_API_BASE_URL="http://10.72.102.12:8081" npm run dev -- --host 0.0.0.0

#ls
#java -jar SmartTowns-0.0.1-SNAPSHOT.jar --server.port=8080

echo "Installing terraform..."
cd /home/debian
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
unzip terraform_1.1.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
