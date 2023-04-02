Build
-----

docker build -t registry.rocketsoftware.com/mobius_demo:12.1.0 .

docker image ls

docker save -o mobius_demo_12.1.tar registry.rocketsoftware.com/mobius_demo:12.1.0

Debug
-----
docker run -it -v mobius12_mobius-data:/mnt/efs --network mobius12_default --name mobius_demo registry.rocketsoftware.com/mobius_demo:12.0.0 bash
docker run -it -v mobius12_mobius-data:/mnt/efs --network mobius12_default -e MV_URL='http://mobiusview:8080/mobius' -e MV_REPOSITORY='Mobius' --name mobius_demo registry.rocketsoftware.com/mobius_demo:12.0.0 bash

./copy-demo.sh


Install
-------
docker load -i ./mobius_demo_12.tar

docker run -v mobius12_mobius-data:/mnt/efs --network mobius12_default --name mobius_demo registry.rocketsoftware.com/mobius_demo:12.0.0


docker run -v mobius12_mobius-data:/mnt/efs --network mobius12_default -e MV_SERVER_PORT='mobiusview:8080' -e MV_REPOSITORY='Mobius' --name mobius_demo registry.rocketsoftware.com/mobius_demo:12.0.0


docker container rm mobius_demo




LOGS
----
rocket@docker:/mnt/hgfs/docker/mobius12/Compose$ docker exec -it mobiusview bash
bash-4.4$ cd /opt/tomcat/logs
bash-4.4$ tail -f catalina.out
10-Jan-2023 17:44:01.133 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory [/opt/apache-tomcat-9.0.65/webapps/mobius]
10-Jan-2023 17:46:38.931 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.



2023-01-10 17:48:40.294 [WARN ]  :  [main] com.hazelcast.instance.Node:log - [172.20.0.8]:6701 [dev] [3.12.12] No join method is enabled! Starting standalone.
10-Jan-2023 17:52:42.131 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory [/opt/apache-tomcat-9.0.65/webapps/mobius] has finished in [520,997] ms
10-Jan-2023 17:52:42.156 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
10-Jan-2023 17:52:42.281 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["https-jsse-nio-8443"]
10-Jan-2023 17:52:42.342 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [521638] milliseconds
exit
^C
bash-4.4$ exit
exit
rocket@docker:/mnt/hgfs/docker/mobius12/Compose$ docker run -v mobius12_mobius-data:/mnt/efs --network mobius12_default --name mobius_demo registry.rocketsoftware.com/mobius_demo:12.0.0
off
Mobius CLI tool
Copyright (C) 2020-2022, Rocket Software, Inc. or its affiliates.  All rights reserved.
Tue Jan 10 17:57:15 2023 - Getting repository information. 
Tue Jan 10 17:57:19 2023 - Repository ID: F6211A23-334E-4572-B49E-0FAD6335EA3E Repository Name: Mobius Repository Type: VDR
Tue Jan 10 17:57:19 2023 - XML request processing started.
Tue Jan 10 17:59:24 2023 - Total entries processed: 50
Tue Jan 10 17:59:24 2023 - XML request processed successfully
Mobius CLI tool
Copyright (C) 2020-2022, Rocket Software, Inc. or its affiliates.  All rights reserved.
Tue Jan 10 17:59:43 2023 - Getting repository information. 
Tue Jan 10 17:59:47 2023 - Repository ID: F6211A23-334E-4572-B49E-0FAD6335EA3E Repository Name: Mobius Repository Type: VDR
Tue Jan 10 17:59:47 2023 - XML request processing started.
Tue Jan 10 18:01:53 2023 - Total entries processed: 4711
Tue Jan 10 18:01:53 2023 - XML request processed successfully
rocket@docker:/mnt/hgfs/docker/mobius12/Compose$ docker container rm mobius_demo
mobius_demo