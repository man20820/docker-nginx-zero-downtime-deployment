docker rm -f container-name-2
docker run -d --name container-name-2 \
-p 3000:3000 \
image_name