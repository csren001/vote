package example02;

import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.sdk.Enrollment;
import org.hyperledger.fabric.sdk.NetworkConfig;
import org.hyperledger.fabric.sdk.User;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric.sdk.security.CryptoSuiteFactory;
import org.hyperledger.fabric_ca.sdk.HFCAClient;
import org.hyperledger.fabric_ca.sdk.RegistrationRequest;

import java.io.File;
import java.nio.file.Paths;
import java.security.PrivateKey;
import java.util.Properties;
import java.util.Set;

public class RegisterUser {
    static {
        System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_localhost", "true");
    }

    private static final String ORGNAME_ORG1 = "Org1";
    private static final String CA_CERT_ORG1 = "profiles/" + ORGNAME_ORG1 + "/tls/" + "ca.org1.example.com-cert.pem";
    //private static final String CA_URL_ORG1 = "http://localhost:7054";
    private static final String MSPID_ORG1 = "Org1MSP";
    private static final String ADMINNAME_ORG1 = "admin";
    private static final String USERNAME_ORG1 = "user01";
    private static final String USERPWD_ORG1 = "user01pw";

    private static final String ORGNAME_ORG2 = "Org2";
    private static final String CA_CERT_ORG2 = "profiles/" + ORGNAME_ORG2 + "/tls/" + "ca.org2.example.com-cert.pem";
    //private static final String CA_URL_ORG2 = "http://localhost:6054";
    private static final String MSPID_ORG2 = "Org2MSP";
    private static final String ADMINNAME_ORG2 = "admin";
    private static final String USERNAME_ORG2 = "user02";
    private static final String USERPWD_ORG2 = "user02pw";

    private static void doRegisterUser(String tlsCert, String orgName, String orgMSP, String adminName, String userName, String userSecret) throws Exception {
        NetworkConfig config = NetworkConfig.fromJsonFile(new File(Paths.get( "profiles", orgName, "connection.json").toString()));
        NetworkConfig.CAInfo caInfo = config.getOrganizationInfo(orgName).getCertificateAuthorities().get(0);
        String caURL = caInfo.getUrl();

        Properties props = new Properties();
        props.put("pemFile", tlsCert);
        props.put("allowAllHostNames", "true");

        HFCAClient caClient = HFCAClient.createNewInstance(caURL, props);
        CryptoSuite cryptoSuite = CryptoSuiteFactory.getDefault().getCryptoSuite();
        caClient.setCryptoSuite(cryptoSuite);
        Wallet wallet = Wallet.createFileSystemWallet(Paths.get("wallet", orgName));

        // Check to see if we've already enrolled the user.
        if (wallet.exists(userName)) {
            System.out.println("An identity for the user \"" + userName + "@" + orgName + "\" already exists in the wallet");
            return;
        }

        if (!wallet.exists(adminName)) {
            System.out.println("\"" + adminName + "@" + orgName + "\" needs to be enrolled and added to the wallet first");
            return;
        }

        Wallet.Identity adminIdentity = wallet.get(adminName);
        Enrollment adminKeys = new Enrollment() {
            @Override
            public PrivateKey getKey() {
                return adminIdentity.getPrivateKey();
            }
            @Override
            public String getCert() {
                return adminIdentity.getCertificate();
            }
        };
        User admin = new UserContext(adminName, orgMSP, adminKeys);

        // Register the user, enroll the user, and import the new identity into the wallet.
        RegistrationRequest registrationRequest = new RegistrationRequest(userName);
//        registrationRequest.setAffiliation("org1.department1");
        registrationRequest.setSecret(userSecret);
       caClient.register(registrationRequest, admin);
        Enrollment enrollment = caClient.enroll(userName, userSecret);
        Wallet.Identity user = Wallet.Identity.createIdentity(orgMSP, enrollment.getCert(), enrollment.getKey());
        wallet.put(userName, user);
        System.out.println("Successfully enrolled user \"" + userName + "@" + orgName + "\" and imported into the wallet");
    }

    public static void main(String[] args) throws Exception {
        doRegisterUser(CA_CERT_ORG1, ORGNAME_ORG1, MSPID_ORG1, ADMINNAME_ORG1, USERNAME_ORG1, USERPWD_ORG1);
        doRegisterUser(CA_CERT_ORG2, ORGNAME_ORG2, MSPID_ORG2, ADMINNAME_ORG2, USERNAME_ORG2, USERPWD_ORG2);
    }
}
