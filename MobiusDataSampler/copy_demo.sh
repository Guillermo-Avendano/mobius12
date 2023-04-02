#!/bin/sh
#
echo 1. Copying DAF files
cp -v -R /home/demo/DAFs/* /mnt/efs

echo 2. Changing files permissions 
chown -R 2002:root /mnt/efs/*
chmod -R 750 /mnt/efs/*

echo Mobius Remote Cli Config: 

sed "s#@MV_REPOSITORY@#$MV_REPOSITORY#g" $HOME/asg/mobius/mobius-cli/application.template.yaml >  $HOME/asg/mobius/mobius-cli/application.tmp
sed "s#@MV_URL@#$MV_URL#g" $HOME/asg/mobius/mobius-cli/application.tmp >  $HOME/asg/mobius/mobius-cli/application.tmp1

sed "s#@MV_BASIC_AUTH_USER@#$MV_BASIC_AUTH_USER#g" $HOME/asg/mobius/mobius-cli/application.tmp1 >  $HOME/asg/mobius/mobius-cli/application.tmp2
sed "s#@MV_BASIC_AUTH_PASS@#$MV_BASIC_AUTH_PASS#g" $HOME/asg/mobius/mobius-cli/application.tmp2 >  $HOME/asg/mobius/mobius-cli/application.yaml

echo ""
echo $MV_SECRET_SEC > /root/asg/security/secret.sec
echo ""

echo 3. Adjust Mobius View URL

cat $HOME/asg/mobius/mobius-cli/application.yaml

echo 4. Loading Content Classes and Indexes definitions
java -cp "BOOT-INF/classes:BOOT-INF/lib/*" com.asg.mobiuscli.MobiusCliApplication vdrdbxml -s Mobius -u ADMIN -f $MV_DEMO_DEFINITIONS -o $MV_DEMO_DEFINITIONS.out -v 2

echo --------------------------------------
echo MobiusCli log
cat mobiuscli.log
echo --------------------------------------

echo 5. Loading references to DAF files and Indexes
java -cp "BOOT-INF/classes:BOOT-INF/lib/*" com.asg.mobiuscli.MobiusCliApplication vdrdbxml -s Mobius -u ADMIN -f $MV_DEMO_LOAD_DATA -o $MV_DEMO_LOAD_DATA.out -v 2

echo --------------------------------------
echo MobiusCli log
cat mobiuscli.log
echo --------------------------------------