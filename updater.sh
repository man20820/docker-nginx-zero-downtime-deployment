#!/bin/bash

# example
# SCRIPT_PATH="/home/man20820/workspace/updater"
# NGINX_VHOST_PATH="/etc/nginx/sites-available/vhost"
# PRIMARY_CONTAINER_URL="127.0.0.1:3000"
# SECONDARY_CONTAINER_URL="127.0.0.1:3001"
# COOLDOWN="30"

SCRIPT_PATH=""
NGINX_VHOST_PATH=""
PRIMARY_CONTAINER_URL=""
SECONDARY_CONTAINER_URL=""
COOLDOWN=""

function is_commented() {
  grep "#server" "$NGINX_VHOST_PATH"
  return $?
}

function activate2() {
  sed -i "s/server $PRIMARY_CONTAINER_URL/#server $PRIMARY_CONTAINER_URL/" "$NGINX_VHOST_PATH"
  sed -i "s/#server $SECONDARY_CONTAINER_URL/server $SECONDARY_CONTAINER_URL/" "$NGINX_VHOST_PATH"
}

function activate1() {
  sed -i "s/server $SECONDARY_CONTAINER_URL/#server $SECONDARY_CONTAINER_URL/" "$NGINX_VHOST_PATH"
  sed -i "s/#server $PRIMARY_CONTAINER_URL/server $PRIMARY_CONTAINER_URL/" "$NGINX_VHOST_PATH"
}

function run1() {
  bash "$SCRIPT_PATH"run1.sh
  sleep $COOLDOWN
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null $PRIMARY_CONTAINER_URL)
  echo $response
  if [ "$response" == "200" ]; then
    activate1
    service nginx reload
    bash "$SCRIPT_PATH"del2.sh
  fi
}

function run2() {
  bash "$SCRIPT_PATH"run2.sh
  sleep $COOLDOWN
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null $SECONDARY_CONTAINER_URL)
  echo $response
  if [ "$response" == "200" ]; then
    activate2
    service nginx reload
    bash "$SCRIPT_PATH"del1.sh
  fi
}

main() {
  IS_COMMENTED=`echo $(is_commented)`
  PRIMARY_CONTAINER="#server $PRIMARY_CONTAINER_URL;"
  SECONDARY_CONTAINER="#server $SECONDARY_CONTAINER_URL;"
  if [ "$IS_COMMENTED" == "$PRIMARY_CONTAINER" ]; then
    run1
    echo "change to primary container"
  fi
  if [ "$IS_COMMENTED" == "$SECONDARY_CONTAINER" ]; then
    run2
    echo "change to secondary container"
  fi
}

main