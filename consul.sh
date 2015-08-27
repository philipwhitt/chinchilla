#!/bin/bash

# wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip
# unzip 0.5.2_linux_amd64.zip
# wget https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip
# unzip 0.5.2_web_ui.zip
# mv dist /tmp/web-ui

./consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -ui-dir /tmp/web-ui &

sleep 5

read -r -d '' CONN_CFG << EOF
user: guest
password: guest
host: localhost
port: 5672
EOF

read -r -d '' FOO_CFG << EOF
name: Foo
queuename: demo.foo
servicehost: http://localhost:8080
uri: /foo
method: POST
EOF

echo "Configuring"
curl -X PUT http://localhost:8500/v1/kv/chinchilla/connection.yaml -d "$CONN_CFG"
curl -X PUT http://localhost:8500/v1/kv/chinchilla/endpoints/foo.yaml -d "$FOO_CFG"

wait