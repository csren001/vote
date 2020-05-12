## Fabric 2.0 Lab Environment

### 1. Lab1 Environment setup
```
# 1. STEPS for Startup Environment
# 1.1. download docker images
# 1.2. download fabric binaries and fabric-ca binaries
./setup.sh

# 2. STEPS for Startup Environment
# 2.1. startup CA servers
# 2.2. register accounts for each organizations including (admin, users, peers)
# 2.3. generate genesis blocks and channel setup transaction files
# 2.4. startup Orderer and Peers with DB 
# 2.5. setup channel
# 2.6. generate connection profile for each peer
. ./init.sh

# 3. STEPS for Deploy Chaincode
# 3.1. package chaincode
# 3.2. install chaincode locally and get package id
# 3.3. approve chaincode installation from org1
# 3.4. get approvals from org2 on channel
# 3.5. check chaincode commit readiness
# 3.6. commit chaincode deployment transaction
# 3.7. check commit status
. scripts/deploy_chaincode.sh

# 4. STEPS for Access Chaincode via CLI
# 4.1. initialize chaincode
# 4.2. query chaincode (ledger-readonly)
# 4.3. invoke chaincode (ledger-write)
. scripts/test_example01.sh
```

### 2. Lab2 Chaincode Development

### 3. Lab3 SDK Development
