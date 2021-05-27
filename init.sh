#!/bin/bash
. ./setup.sh

echo "0.Initialize"
mkdir -p ${PWD}/tmp
mkdir -p organizations/fabric-ca/org1
mkdir -p organizations/fabric-ca/org2
mkdir -p organizations/fabric-ca/ordererOrg
cp organizations/fabric-ca/ca.org1.example.com.yaml organizations/fabric-ca/org1/fabric-ca-server-config.yaml
cp organizations/fabric-ca/ca.org2.example.com.yaml organizations/fabric-ca/org2/fabric-ca-server-config.yaml
cp organizations/fabric-ca/ca.orderer.example.com.yaml organizations/fabric-ca/ordererOrg/fabric-ca-server-config.yaml
echo

echo "1.Startup CA Services in Network"
CA_IMAGE_TAG=${CA_VERSION} docker-compose -f docker/docker-compose-ca.yaml up -d
echo

sleep 5

echo "2.Register Peers and Orderer with users"
. organizations/fabric-ca/registerEnroll.sh 
createOrg1
createOrg2
createOrderer
echo

echo "3.Create orderer.genesis.block"
. scripts/utils.sh
setupCommonENV
export FABRIC_CFG_PATH=${PWD}/configtx
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
echo

echo "4.Startup Peers and Orderer"
COMPOSE_FILE_BASE=docker/docker-compose-ABC.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=${FABRIC_VERSION} DB_IMAGE_TAG=${DB_VERSION} docker-compose -f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_COUCH} up -d
echo

sleep 5

echo "5.Create & Join Channel"
. scripts/setup_channel.sh
echo

echo "6.Generate Connection Profiles"
./organizations/ccp-generate.sh

if [ ! -d "${PWD}/app/profiles/Org1/tls" ]; then 
    mkdir -p app/profiles/Org1/tls
fi
if [ ! -d "${PWD}/app/profiles/Org2/tls" ]; then 
    mkdir -p app/profiles/Org2/tls
fi

cp ./organizations/peerOrganizations/org1.example.com/connection-org1.json app/profiles/Org1/connection.json
cp ./organizations/peerOrganizations/org2.example.com/connection-org2.json app/profiles/Org2/connection.json
cp ./organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem app/profiles/Org1/tls/
cp ./organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem app/profiles/Org2/tls/
echo

echo "7.deploy chaincode"
. scripts/deploy_chaincode.sh java ${PWD}/chaincode/java mycc_java
echo

echo "8.init chaincode"
. scripts/test_example01.sh mycc_java
echo

echo "9.clear wallets"
. scripts/clear_wallets.sh
echo

echo "10.Enroll admin"
cd app
java -classpath ./target/vote-1.0-SNAPSHOT-jar-with-dependencies.jar example02.EnrollAdmin Org1
java -classpath ./target/vote-1.0-SNAPSHOT-jar-with-dependencies.jar example02.EnrollAdmin Org2
echo

echo "Done."
