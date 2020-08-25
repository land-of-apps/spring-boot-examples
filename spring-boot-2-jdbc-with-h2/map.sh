#!/usr/bin/env bash

trap "cat map.log" EXIT

set -x
mvn -DskipTests=true package
mvn -DskipTests=true spring-boot:run -Dspring-boot.run.jvmArguments="-javaagent:../appmap.jar -Dappmap.output.directory=../tmp/appmap -Dappmap.record=com.in28minutes.springboot.jdbc.h2.example.SpringBoot2JdbcWithH2Application.main -Dmanagement.endpoint.shutdown.enabled=true -Dmanagement.endpoints.web.exposure.include=*" >map.log 2>&1 &
pid=$!

set +x
for i in {1..60}; do
 curl -fsS http://localhost:8080/actuator/health >/dev/null 2>&1 && break
 sleep 2
done
set -x
curl -fsS http://localhost:8080/actuator/health || exit 1
:

curl -fsS -X POST http://localhost:8080/actuator/shutdown
:

# Looks like database might not being shut down cleanly, but we don't
# really care....
wait -f $pid || true

