#!bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install nginx -y

sudo rm /etc/nginx/sites-available/default
sudo cp ~/sg_application_from_aws/nginx.conf /etc/nginx/sites-available/default

# wget https://github.com/ansonwhc/eng110-cicd/archive/main.zip
# sudo apt-get install unzip
# unzip main.zip
# sudo rm main.zip

# install nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y

cd ~/sg_application_from_aws/app/
sudo npm install
sudo npm install pm2 -g

pm2 kill -all
sudo pkill node -f
sudo pkill nginx -f
sudo systemctl restart nginx
sudo systemctl enable nginx
#sudo pm2 start app.js
nohup node app.js > /dev/null 2>&1 &
# npm start &
