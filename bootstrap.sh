#!/bin/bash -l

#BASE
sudo apt-get -qq update
sudo apt-get install -y python python-pip python-twisted vim curl python-software-properties

# requirements for scrapy
sudo apt-get -qq update
sudo apt-get install -y python-dev libxml2-dev libxslt-dev libffi-dev

# requirements for django extensions
sudo apt-get -qq update
sudo apt-get install -y graphviz

# elasticsearch & requirements
# open JDK 7
# kopf plugin for elastic search
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
add-apt-repository -r "deb http://packages.elastic.co/elasticsearch/1.6/debian stable main"
echo "deb http://packages.elastic.co/elasticsearch/1.6/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get -qq update
sudo apt-get -y install openjdk-7-jre elasticsearch
sudo sed -i 's/\/var\/run\/elasticsearch/\/var\/run/g' /etc/init.d/elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
sudo /usr/share/elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf
sudo /etc/init.d/elasticsearch restart


# install node.js and NPM
# install PPA first to get recent package
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get -qq update
sudo apt-get install -y nodejs build-essential

# install client project requirements and the grunt-CLI task runner globally
cd /vagrant
npm install
sudo npm install -g grunt-cli

# install sass
sudo gem install sass

#django project requirements
cd /vagrant
sudo pip install -r requirements.txt

#set up django project with migrations and admin account
cd offenesparlament
python manage.py makemigrations
python manage.py migrate

# python manage.py createsuperuser
# Create the superuser without interaction. username: admin; password: admin
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | ./manage.py shell