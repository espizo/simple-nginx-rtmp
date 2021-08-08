# simple-nginx-rtmp

This is a very simple nginx-rtmp setup I'm using to pull a remote stream, record it, and then restream it to another rtmp server.

Any streams pushed to http://localhost/stream/$name will be recorded in /tmp/rec on the host fs.

Recordings can be seen at http://localhost/rec/

Stats and an embedded player can be seen at http://localhost/

For stats in xml or json: http://localhost/stat.xml and http://localhost/stat.json

## Building and Running

`$ ./build.sh && ./run.sh`

