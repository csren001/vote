package application;
import org.hyperledger.fabric.gateway.*;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeoutException;

public class InvokeCreateVote {
        static {
            System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_localhost", "true");}

        private static final String CHANNEL_NAME = "mychannel";
        private static final String CONTRACT_NAME = "mycc_java";
        public static void doCreateVote(String orgName, String userName, String functionName, String key, String value) 
        		throws IOException, ContractException, TimeoutException, InterruptedException {
            //get user identity from wallet.
            Path walletPath = Paths.get("/home/csren/vote/app/wallet", orgName);
            Wallet wallet = Wallets.newFileSystemWallet(walletPath);
            Identity identity = wallet.get(userName); 
            //check identity existence in wallet
            if (identity == null) {
                System.out.println("The identity \"" + userName + "@"+ orgName + "\" doesn't exists in the wallet");
                return;
            }
            //load connection profile
            Path networkConfigPath = Paths.get( "/home/csren/vote/app/profiles", orgName, "connection.json");
            Gateway.Builder builder = Gateway.createBuilder();
            builder.identity(wallet, userName).networkConfig(networkConfigPath).discovery(true);
            // create a gateway connection
            try (Gateway gateway = builder.connect()) {
                // get the network and contract
                Network network = gateway.getNetwork(CHANNEL_NAME);
                Contract contract = network.getContract(CONTRACT_NAME);
                byte[] result = contract.submitTransaction(functionName, key, value);
                System.out.println("create vote successfully");
            }
        }
        public static void main(String[] args) {
            try {
                doCreateVote(args[0], args[1], "CreateVote", "vote02", "{\"A\":\"10\",\"B\":\"0\"}");
            } catch (IOException | ContractException | TimeoutException | InterruptedException e) {
                e.printStackTrace();
            }
        }
}

