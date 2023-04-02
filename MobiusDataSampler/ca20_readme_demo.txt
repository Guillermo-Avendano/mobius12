k3d image load mobius_demo_12.1.tar -c zenith
docker run -it --rm -p 8080:8080 rodolpheche/wiremock
kubectl -n zenith run -i --tty demo-pod --image=registry.rocketsoftware.com/mobius_demo:12.1.0 -- bash

Summary

User name
demo
First name
Demo
Last name
asg!tWo3
demo
Password
mPSITIw@

java -cp "BOOT-INF/classes:BOOT-INF/lib/*" com.asg.mobiuscli.MobiusCliApplication 

curl -d "client_id=mobius_demo_12.01" -d "client_secret=0d94c472-9715-477f-a3e4-10d6e48cef87" -d "username=ADMIN" -d "password=" -d "grant_type=client_credentials" http://asg-idp-service-http:80/auth/realms/master/protocol/openid-connect/token



Client Id
mobius_demo_12.01
Secret
0d94c472-9715-477f-a3e4-10d6e48cef87


kubectl apply -f job_mobius12_demo_ca20.yaml

kubectl get jobs -n zenith

kubectl logs job/mobius12-demo -n zenith

kubectl delete job/mobius12-demo -n zenith



mobius-view deployment
    - name: ASG_SECURITY_OPENIDCONNECTTWO_SERVICETOKENSETTINGS_OIDCCONFIG_SERVICETOKENURL
      value: http://asg-idp-service-http:80/auth/realms/master/protocol/openid-connect/token

    - name: ASG_SECURITY_OPENIDCONNECTTWO_SERVICETOKENSETTINGS_OIDCCONFIG_SERVICETOKENS_0_CLIENTSECRET
      valueFrom:
        secretKeyRef:
          key: value
          name: asg-mobius-view-service-client-secret=NzAyMmNiMjgtMWVjZi00NjI4LWJmZWQtODZhMjY0ODgxNTM2 -> decode 64: 7022cb28-1ecf-4628-bfed-86a264881536
		  
application.yaml - MobiusRemoteCLI
		  
        clientCredentials:
          tokenUrl: "http://asg-idp-service-http:80/auth/realms/master/protocol/openid-connect/token"
          clientId: "mobius-remote-cli"
          clientSecret: "ASG_ENC(vTPjFi5pEWFvJDM16EI6an8+vrLSd68CUN6ItK4SWH5kfuviRIIhE9LkzG1HF+QlgFUEFb2vWK4uzytAkXqtJQ==)"
		  
		  
		  
---------------------------------------

demo-pod:/home/demo# cat /root/asg/mobius/mobius-cli/application.yaml
asg:
  mobius:
    cli:
      repos:
      - repositoryName: "Mobius"
        repositoryUrl: "http://asg-mobius-view/mobius"
        userName: "ADMIN"
      user:
        clientCredentials:
          tokenUrl: "http://asg-idp-service-http:80/auth/realms/master/protocol/openid-connect/token"
          clientId: "mobius-remote-cli"
          clientSecret: "ASG_ENC(vTPjFi5pEWFvJDM16EI6an8+vrLSd68CUN6ItK4SWH5kfuviRIIhE9LkzG1HF+QlgFUEFb2vWK4uzytAkXqtJQ==)"
		  
		  
 Mobius CLI tool
Copyright (C) 2020-2022, Rocket Software, Inc. or its affiliates.  All rights reserved.
com.asg.services.common.exceptions.InternalErrorException: Access token is not received as part of response - {"error":"invalid_client","error_description":"Invalid client credentials"}
        at com.asg.services.common.security.openidconnect.JWTUtility.generateServiceToken(JWTUtility.java:881)
        at com.asg.mobiuscli.configure.impl.AuthManager.generateServiceToken(AuthManager.java:87)
        at com.asg.mobiuscli.configure.impl.AuthManager.configure(AuthManager.java:51)
        at com.asg.mobiuscli.MobiusCliApplication.run(MobiusCliApplication.java:85)
        at org.springframework.boot.SpringApplication.callRunner(SpringApplication.java:771)
        at org.springframework.boot.SpringApplication.callRunners(SpringApplication.java:755)
        at org.springframework.boot.SpringApplication.run(SpringApplication.java:315)
        at com.asg.mobiuscli.MobiusCliApplication.main(MobiusCliApplication.java:79)
Wed Mar 08 18:34:54 2023 - Getting repository information.

------------------4
demo-pod1:/home/demo# more /root/asg/mobius/mobius-cli/application.yaml 
asg:
  mobius:
    cli:
      repos:
      - repositoryName: "Mobius"
        repositoryUrl: "http://mobiusview:8080/mobius"
        userName: "ADMIN"
      user:
        basicauth:
          userName: "admin"
          password: "ASG_ENC(IzrmGPXQqWV3/d6f1kq/Bw==)"
        clientCredentials:
          tokenUrl: "http://asg-idp-service-http:80/auth/realms/master/protocol/openid-connect/token"
          clientId: "zenith-mobius-view-s2s"
          clientSecret: "ASG_ENC(K+5ZIWgYPehTiWyRBxXQ/2eUKtoqsaxPNohVonVA17B8JiedUITVWNl7S8eFndrC)"      -> 7022cb28-1ecf-4628-bfed-86a264881536

------------ definitivo 13 de Marzo

asg:
  mobius:
    cli:
      repos:
      - repositoryName: "Mobius"
        repositoryUrl: "http://asg-mobius-view:80/mobius"
        userName: "ADMIN"
      user:
        basicauth:
          userName: "admin"
          password: "ASG_ENC(c1LpoXEIRe3h7b6TVoDfNP91rGK/9wGM)"


