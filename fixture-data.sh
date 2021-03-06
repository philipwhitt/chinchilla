#!/bin/bash

USER=$(./chinchilla -keyring ./test-keys/.pubring.gpg encrypt guest)
PASS=$(./chinchilla -keyring ./test-keys/.pubring.gpg encrypt guest)

read -r -d '' CONN_CFG << EOF
user: $USER
password: $PASS
vhost: /
servicename: rabbitmq
EOF

read -r -d '' FOO_CFG << EOF
name: Foo
servicename: foo
uri: /foo
method: POST
queueconfig:
  prefetch: 5
  queuename: demo.foo
EOF

read -r -d '' TOPIC_CFG << EOF
name: Topic
servicename: foo
uri: /foo
method: POST
consumerstrategy: topic
queueconfig:
  prefetch: 5
  topicname: foo.*
  queuename: all-foos
  exchangename: demo
EOF

read -r -d '' TOPIC2_CFG << EOF
name: Topic2
servicename: foo
uri: /foo
method: POST
consumerstrategy: topic
queueconfig:
  prefetch: 5
  topicname: foo.*
  queuename: more-foos
  exchangename: demo
EOF

read -r -d '' RABBIT_SVC << EOF
{
  "ID": "rabbitmq1",
  "Name": "rabbitmq",
  "Address": "127.0.0.1",
  "Port": 5672
}
EOF
read -r -d '' FOO_SVC << EOF
{
  "ID": "foo1",
  "Name": "foo",
  "Address": "127.0.0.1",
  "Port": 8080
}
EOF

echo "Configuring"
curl -X PUT http://127.0.0.1:8500/v1/agent/service/register -d "$RABBIT_SVC"
curl -X PUT http://127.0.0.1:8500/v1/agent/service/register -d "$FOO_SVC"

curl -X PUT http://127.0.0.1:8500/v1/kv/chinchilla/connection.yaml -d "$CONN_CFG"
curl -X PUT http://127.0.0.1:8500/v1/kv/chinchilla/endpoints/foo.yaml -d "$FOO_CFG"
curl -X PUT http://127.0.0.1:8500/v1/kv/chinchilla/endpoints/topic.yaml -d "$TOPIC_CFG"
curl -X PUT http://127.0.0.1:8500/v1/kv/chinchilla/endpoints/topic2.yaml -d "$TOPIC2_CFG"






wait

