# Clone this repository

```bash
mkdir updater
cd updater
git clone https://github.com/man20820/docker-nginx-zero-downtime-deployment.git .
```

# Set your configuration on updater.sh

```bash
nano updater.sh

SCRIPT_PATH="/home/man20820/workspace/updater"
NGINX_VHOST_PATH="/etc/nginx/sites-available/vhost"
PRIMARY_CONTAINER_URL="127.0.0.1:3000"
SECONDARY_CONTAINER_URL="127.0.0.1:3001"
COOLDOWN="30"
```

# Set your docker run script

Set run1 & del1 for primary container, run2 & del2 for secondary container

```bash
docker rm -f ...
docker run ...
```

# Set your nginx vhost configuration

Set nginx vhost configuration like using loadbalancer, the example is on etc/nginx/sites-available/vhost

```bash
upstream backend {
    server 127.0.0.1:3000;
    #server 127.0.0.1:3001;
}
```

# Run updater script

```bash
bash updater.sh
```

# Example output

```bash
~# bash /home/man20820/workspace/updater.sh
test-container-2
92874f56a44ad2af4b2425e90e4645dff3acfd78b1c0a02e9964937eaf2a28f0
change to primary container
```

```bash
~# bash /home/man20820/workspace/updater.sh
test-container-1
c311923738b0fb51ebb1d91e3d7c873407abbb706400958ad85d9dc8bb13acf9
change to secondary container
```
