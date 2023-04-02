#!/bin/sh
#
echo 1. Deleting DAF files
ls DAFs > daf_files.log

lines=$(cat daf_files.log)
for p in $lines
do
  rm -f -R /mnt/efs/${p}
done

sed "s#add/modify#delete#g" $MV_DEMO_DEFINITIONS >  $MV_DEMO_DEFINITIONS.delete.xml
sed "s#add/modify#delete#g" $MV_DEMO_LOAD_DATA >  $MV_DEMO_LOAD_DATA.delete.xml

echo 2. Adjusting Mobius Remote Cli Config 

sed "s#@MV_REPOSITORY@#$MV_REPOSITORY#g" $HOME/asg/mobius/mobius-cli/application.template.yaml >  $HOME/asg/mobius/mobius-cli/application.tmp
sed "s#@MV_URL@#$MV_URL#g" $HOME/asg/mobius/mobius-cli/application.tmp >  $HOME/asg/mobius/mobius-cli/application.tmp1

sed "s#@MV_BASIC_AUTH_USER@#$MV_BASIC_AUTH_USER#g" $HOME/asg/mobius/mobius-cli/application.tmp1 >  $HOME/asg/mobius/mobius-cli/application.tmp2
sed "s#@MV_BASIC_AUTH_PASS@#$MV_BASIC_AUTH_PASS#g" $HOME/asg/mobius/mobius-cli/application.tmp2 >  $HOME/asg/mobius/mobius-cli/application.yaml

echo ""
echo $MV_SECRET_SEC > /root/asg/security/secret.sec
echo ""

echo 3. Mobius Remote Cli Config

cat $HOME/asg/mobius/mobius-cli/application.yaml

echo 4. Deleting references to DAF files and Indexes
java -cp "BOOT-INF/classes:BOOT-INF/lib/*" com.asg.mobiuscli.MobiusCliApplication vdrdbxml -s Mobius -u ADMIN -f $MV_DEMO_LOAD_DATA.delete.xml -o $MV_DEMO_LOAD_DATA.delete.xml.out -v 2

echo --------------------------------------
echo MobiusCli log
cat mobiuscli.log
echo --------------------------------------

echo 5. Deleting Content Classes and Indexes definitions
java -cp "BOOT-INF/classes:BOOT-INF/lib/*" com.asg.mobiuscli.MobiusCliApplication vdrdbxml -s Mobius -u ADMIN -f $MV_DEMO_DEFINITIONS.delete.xml -o $MV_DEMO_DEFINITIONS.delete.xml.out -v 2

echo --------------------------------------
echo MobiusCli log
cat mobiuscli.log
echo --------------------------------------