#!/bin/bash
COMPOSE_PROJECT_NAME=dash_supply
export CHANNEL_NAME=supplychannel
LANGUAGE="golang"
DELAY=3
TIMEOUT=20
LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=5

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supply.com/orderers/orderer.supply.com/msp/tlscacerts/tlsca.supply.com-cert.pem
CC_SRC_PATH="github.com/chaincode/supplyContract"
# verify the result of test
verifyResult () {
	if [ $1 -ne 0 ] ; then
		echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute generate.sh ==========="
		echo
   		exit 1
	fi
}

setGlobals () {
	ORG=$2
	if [ $ORG -eq 1 ] ; then
		CORE_PEER_LOCALMSPID="Org1MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.supply.com/peers/peer0.org1.supply.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.supply.com/users/Admin@org1.supply.com/msp
		if [ $1 -eq 0 ]; then
			CORE_PEER_ADDRESS=peer0.org1.supply.com:7051
			PEER=PEER0
		else
			CORE_PEER_ADDRESS=peer1.org1.supply.com:7051
			PEER=PEER1
		fi
	elif [ $ORG -eq 2 ] ; then
		CORE_PEER_LOCALMSPID="Org2MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.supply.com/peers/peer0.org2.supply.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.supply.com/users/Admin@org2.supply.com/msp
		if [ $1 -eq 0 ]; then
			CORE_PEER_ADDRESS=peer0.org2.supply.com:7051
			PEER=PEER2
		else
			CORE_PEER_ADDRESS=peer1.org2.supply.com:7051
			PEER=PEER3
		fi
	elif [ $ORG -eq 3 ] ; then
		CORE_PEER_LOCALMSPID="Org3MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.supply.com/peers/peer0.org3.supply.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.supply.com/users/Admin@org3.supply.com/msp
		if [ $1 -eq 0 ]; then
			CORE_PEER_ADDRESS=peer0.org3.supply.com:7051
			PEER=PEER4
		else
			CORE_PEER_ADDRESS=peer1.org3.supply.com:7051
			PEER=PEER5
		fi		
	else
		echo "================== ERROR !!! ORG OR PEER Unknown =================="
	fi

	env |grep CORE
}

setGlobals 0 1

peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac1_lens", "fac1", "lens", "10", "5", "product created, give product directly to fac4", "NULL"]}' >&log.txt
cat log.txt
sleep 1
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac0_flash", "fac1", "flash", "10", "3", "product created", "NULL"]}' >&log.txt
cat log.txt
sleep 1
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "logi0_flash", "logi0", "flash", "0", "1", "delivery from fac1 to fac4", "%fac0_flash%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac0_flash", "logi0_flash", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "fac1_lens", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "logi0_flash", "1"]}' >&log.txt
cat log.txt
sleep 1
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac4_camera_module", "fac4", "camera_module", "1", "15", "product created, assembeled in line A", "%fac1_lens%%logi0_flash%"]}' >&log.txt
cat log.txt
sleep 1
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "ware0_camera_module", "ware0", "camera_module", "0", "15", "product created, move to warehouse0", "%fac4_camera_module%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac4_camera_module", "ware0_camera_module", "1"]}' >&log.txt
sleep 1
cat log.txt
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac2_battery", "fac2", "battery", "10", "15", "product created", "NULL"]}' >&log.txt
sleep 1
cat log.txt
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "logi1_battery", "logi1", "battery", "0", "1", "delivery from fac2 to fac4", "%fac2_battery%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac2_battery", "logi1_battery", "1"]}' >&log.txt
cat log.txt
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "ware0_battery", "ware0", "battery", "0", "20", "store to warehouse0", "%logi1_battery%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "logi1_battery", "ware0_battery", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac5_display", "fac5", "display", "15", "50", "product created", "NULL"]}' >&log.txt
cat log.txt
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "ware0_display", "ware0", "display", "0", "50", "deliverd directly from fac5", "%fac5_display%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac5_display", "ware0_display", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac3_frame", "fac3", "frame", "15", "10", "product created", "NULL"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "logi2_frame", "logi2", "frame", "15", "10", "delivery from fac3 to warehouse0", "NULL"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "ware0_frame", "ware0", "frame", "0", "10", "store to warehouse 0", "%logi2_frame%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac3_frame", "logi2_frame", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "logi2_frame", "ware0_frame", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "ware0_camera_module", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "ware0_battery", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "ware0_display", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["useProduct", "ware0_frame", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "fac6_smartphone", "fac6", "smartphone", "1", "150", "prouct created, assembled in line6B", "%ware0_camera_module%%ware0_battery%%ware0_display%%ware0_frame%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "logi3_smartphone", "logi3", "smartphone", "0", "1", "stock to store0", "%fac6_smartphone%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "stor0_smartphone", "stor0", "smartphone", "0", "200", "stock to store0", "%logi3_smartphone%"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "fac6_smartphone", "logi3_smartphone", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "logi3_smartphone", "stor0_smartphone", "1"]}' >&log.txt
cat log.txt
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["setProduct", "user0_smartphone", "user0", "smartphone", "0", "200", "buy at store0", "%stor0_smartphone%"]}' >&log.txt
cat log.txt 
sleep 3
peer chaincode invoke -o orderer.supply.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n supplycc -c '{"Args":["moveProduct", "stor0_smartphone", "user0_smartphone", "1"]}' >&log.txt
cat log.txt