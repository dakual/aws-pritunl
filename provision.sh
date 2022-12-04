#!/bin/bash -xe
# exec > >(tee /var/log/pritunl-install.log|logger -t user-data -s 2>/dev/console) 2>&1yes

sudo apt update
sudo apt install gnupg2 wget curl -y

echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
curl -sSL https://www.mongodb.org/static/pgp/server-5.0.asc  -o mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --import ./mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --export > ./mongoserver_key.gpg
sudo mv mongoserver_key.gpg /etc/apt/trusted.gpg.d/

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
echo "deb http://repo.pritunl.com/stable/apt $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/pritunl.list

sudo apt update
sudo apt install mongodb-org pritunl wireguard wireguard-tools -y
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod