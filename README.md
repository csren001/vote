## Fabric 2.0 Lab Environment

### 0. Prepare
```bash
############### common packages ####################
# install utilities
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common 
sudo apt-get install -y unzip git  curl wget vim tree jq

# install gradle
cd /tmp && wget https://services.gradle.org/distributions/gradle-6.4-bin.zip
unzip gradle-6.4-bin.zip
sudo mv gradle-6.4 /usr/local/gradle
sudo cat >> ~/.bashrc <<EOF
# setup gradle environments
# =====================
export PATH=$PATH:/usr/local/gradle/bin
# =====================
EOF
source ~/.bashrc 

# download workspace from gitlab.com
git clone https://gitlab.com/qubing/blockchain_lab_v2.git ~/workspace

############### docker ####################
# import docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable"

# update repository index & install docker-ce
sudo apt-get update & sudo apt-get install -y docker-ce

# check docker version
docker -v
# check docker image list (only root can use docker by default)
docker images
# enable  current user to use docker (!!! need to re-login via terminal !!!)
sudo gpasswd -a ${USER} docker
# check docker image list
docker images

#Tips: Speed up docker hub access in China
sudo cat > /etc/docker/daemon.json <<EOF{
    "registry-mirrors": ["https://registry.docker-cn.com"] 
}
EOF
sudo systemctl daemon-reload 
sudo systemctl restart docker

############### docker images ####################
# image of ca
docker pull hyperledger/fabric-ca:1.4.6
# image of peer
docker pull hyperledger/fabric-peer:2.1.0
# image of orderer
docker pull hyperledger/fabric-orderer:2.1.0
# image of tools & utilities
docker pull hyperledger/fabric-tools:2.1.0
# image of Chaincode deployment for Programming Languages (Go | Java | Node.JS)
docker pull hyperledger/fabric-ccenv:2.1.0
docker pull hyperledger/fabric-javaenv:2.1.0
docker pull hyperledger/fabric-nodeenv:2.1.0
# image of Base-OS of Chaincode runtime
docker pull hyperledger/fabric-baseos:0.4.20
# image of coucddb (one NOSQL DB for ledger state)
docker pull hyperledger/fabric-couchdb:0.4.20

# check image list to validate downloading
docker images

############### docker-compose ####################
# download
$ wget https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` 
# copy to ` /usr/local/bin/ ` and rename
$ sudo mv docker-compose-`uname -s`-`uname -m` /usr/local/bin/docker-compose
# make executable
$ sudo chmod +x /usr/local/bin/docker-compose
# validate installation
$ docker-compose -v

############### programming languages ####################
# install Go
cd /tmp && wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz
sudo cat >> ~/.bashrc <<EOF
# setup go environments
# =====================
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/gopath 
export GO111MODULE=on 
export GOPROXY=https://goproxy.cn
# =====================
EOF
source ~/.bashrc
go version

# install Java
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
java -version

# install `nvm`
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# validate installation of `nvm`
nvm --version
# install Node.JS version 10
nvm install 10
# check the version of Node.JS and NPM
node -v
npm -v

############## download fabric binaries #################
# set environment variables
BASE_PATH=https://github.com/hyperledger
FABRIC_VERSION=2.1.0 
CA_VERSION=1.4.6
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')") 
FILE_NAME=hyperledger-fabric-${ARCH}-${FABRIC_VERSION}.tar.gz
CA_FILE_NAME=hyperledger-fabric-ca-${ARCH}-${CA_VERSION}.tar.gz
cd /tmp
# download fabric binaries and fabric-ca binaries
wget ${BASE_PATH}/fabric/releases/download/v${FABRIC_VERSION}/${FILE_NAME}
wget ${BASE_PATH}/fabric-ca/releases/download/v${CA_VERSION}/${CA_FILE_NAME} 
# copy binaries
mkdir -p ~/workspace/fabric-bin/${FABRIC_VERSION} && cd ~/workspace/fabric-bin/${FABRIC_VERSION}
tar zxf /tmp/${FILE_NAME}
tar zxf /tmp/${CA_FILE_NAME} 
chmod +x bin/* && sudo cp bin/* /usr/local/bin/

#Tips:  download link on pan.baidu.com
#链接:https://pan.baidu.com/s/1PSFgdKt6ijcu4UFDyAa9UA 
#提取码:8p2z 

```

### 1. Lab1 Environment setup
```bash
# 1. STEPS for Setup Environment
# 1.2. download docker images
# 1.3. download fabric binaries and fabric-ca binaries
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
