#!/bin/sh

# update and install dependencies
apt-get update
apt-get install -y apt-transport-https curl lsb-core

# linux opend files limit setup
ulimit -n 4096

curl -sL https://github.com/Kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_amd64.tar.gz -o deck.tar.gz
tar -xf deck.tar.gz -C /tmp
sudo cp /tmp/deck /usr/local/bin/

sudo chown root:kong /usr/local/bin/deck
sudo chmod 755 /usr/local/bin/deck

apt-get install -y  git

# setup postgresql database
# create kong db user &amp; kong database
apt-get install -y postgresql postgresql-contrib
su - postgres -c "createuser -s kong"
sudo -u postgres psql -c "ALTER USER kong WITH PASSWORD 'kong';"
su - postgres -c "createdb kong"


cat <<EOF >> /etc/postgresql/13/main/pg_hba.conf
host all all 0.0.0.0/0 trust
EOF

 echo "deb [trusted=yes] https://download.konghq.com/gateway-3.x-debian-$(lsb_release -sc)/ \
 default all" | sudo tee /etc/apt/sources.list.d/kong.list

sudo apt-get update

apt install -y kong-enterprise-edition=3.1.1.1

cat <<EOF > /etc/kong/license.json
{ "license": { "version": 1, "signature": "d63f5f8e38006cd61ef7d82747e99e30616869dd08af28df0682cd86fc4dfb1dd655880a526eb1585401d653c4dbe188fa2d8e13d8165a47eab0f10063e55e9a", "payload": { "customer": "Kong Inc. SEs", "license_creation_date": "2022-05-18", "product_subscription": "Kong Enterprise Subscription", "support_plan": "Platinum", "admin_seats": "1", "dataplanes": "1000", "license_expiration_date": "2023-06-30", "license_key": "0011K000022IA3HQAW_a1V1K000007KlJMUA0" } }}
EOF
    chown root:kong /etc/kong/license.json
    chmod 640 /etc/kong/license.json

echo "Setting up Kong database"

# PGPASSWORD=$(aws_get_parameter "db/password/master")
# DB_HOST=$(aws_get_parameter "db/host")
# DB_NAME=$(aws_get_parameter "db/name")
# DB_PASSWORD=$(aws_get_parameter "db/password")
# export PGPASSWORD

export MANAGER_HOST=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`
export PORTAL_HOST=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`

cat <<EOF > /etc/kong/kong.conf
# kong.conf, Kong configuration file
# Written by Dennis Kelly <dennisk@zillowgroup.com>
# Updated by Dennis Kelly <dennis.kelly@konghq.com>
#
# 2020-01-23: Support for EE Kong Manager Auth
# 2019-09-30: Support for 1.x releases and Dev Portal
# 2018-03-13: Support for 0.12 and load balancing
# 2017-06-20: Initial release
#
# Notes:
#   - See kong.conf.default for further information

# Database settings
database = postgres 
pg_host = localhost
pg_user = kong
pg_password = kong
pg_database = kong

# Load balancer headers
real_ip_header = X-Forwarded-For
trusted_ips = 0.0.0.0/0

# SSL terminiation is performed by load balancers
proxy_listen = 0.0.0.0:8000
# For /status to load balancers
admin_listen = 0.0.0.0:8001

# Enterprise Edition Settings
# SSL terminiation is performed by load balancers
admin_gui_listen  = 0.0.0.0:8002
portal_gui_listen = 0.0.0.0:8003
portal_api_listen = 0.0.0.0:8004

admin_api_uri = http://$MANAGER_HOST:8001
admin_gui_url = http://$MANAGER_HOST:8002

portal              = on
portal_gui_protocol = https
portal_gui_host     = PORTAL_HOST:8003
portal_api_url      = http://$PORTAL_HOST:8004
portal_cors_origins = http://$PORTAL_HOST:8003, http://$PORTAL_HOST:8004

vitals = on
EOF

chmod 640 /etc/kong/kong.conf
chgrp kong /etc/kong/kong.conf

sudo -u kong KONG_PASSWORD=KongRul3z! kong migrations bootstrap

sudo -u kong kong start

git clone https://github.com/mod42/demo-project-deck.git

cd ./demo-project-deck

deck sync

