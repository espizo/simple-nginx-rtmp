mkdir -p /tmp/rec;
docker run -it -v /tmp/rec:/srv/rec -p 80:80 -p 1935:1935 simple-nginx-rtmp
