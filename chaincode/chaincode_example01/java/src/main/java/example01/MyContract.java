package example01;

import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.*;
import org.hyperledger.fabric.shim.ChaincodeStub;

/**
 * Class: MyContract
 */
@Contract(
    name = "example01.MyContract",
    info = @Info(
        title = "MyContract",
        description = "SmartContract Example 01 - Blockchain Workshop",
        version = "1.0.0",
        license = @License(
            name = "Apache 2.0 License",
            url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
        contact = @Contact(
            email = "23227732@qq.com",
            name = "Bing"
        )
    )
)
@Default
public final class MyContract implements ContractInterface {
    /**
     * Initialize Ledger
     * @param ctx context
     */
    @Transaction(name = "Init", intent = Transaction.TYPE.SUBMIT)
    public void init(final Context ctx) {
        ChaincodeStub stub = ctx.getStub();
        stub.putStringState("Name", "Fabric@Java");
    }

    /**
     * Query Ledger
     * @param ctx context
     * @return name state in ledger
     */
    @Transaction(name = "Hi", intent = Transaction.TYPE.EVALUATE)
    public String hi(final Context ctx) {
        ChaincodeStub stub = ctx.getStub();
        return stub.getStringState("Name");
    }
}

