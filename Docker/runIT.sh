#!/bin/bash

if [[ ! $(cat /proc/1/sched | head -n 1 | grep init) ]]
then
   echo 'running in a docker container :-)'
else
   echo 'not running in a docker container - exit 1 to avoid destruction and crash :-)'
   exit 1
fi
BRANCH=$1
if [ -z "$BRANCH" ]
then
    echo 'the branch to build is missing (first parameter) - exit 12'
    exit 12
fi
VERSION="$2"
if [ -z "$VERSION" ]
then
    echo 'the version parameter of form x.y.z is missing (second parameter) - exit 12'
    exit 12
fi
echo "building branch $BRANCH with version $VERSION [version is unused as long as no db-its are executed]"
git pull --strategy=recursive -Xtheirs --no-edit --depth=1 --allow-unrelated-histories
git checkout $BRANCH

cd /opt/robertalab/OpenRobertaParent
mvn clean install -DskipTests -DskipITs

# execute all tests, including the integration tests
mvn install -Pdebug,runIT
RC=$?
echo "maven return code is $RC"
 
case $RC in
  0) echo "returning SUCCESS"
     exit 0 ;;
  *) echo "returning ERROR"
     exit 16 ;;
esac