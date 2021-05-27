package contract;

import com.alibaba.fastjson.JSONObject;

import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.*;
import org.hyperledger.fabric.shim.ChaincodeStub;
import jdk.nashorn.api.scripting.JSObject;

/**
 * Class: MyContract
 */
@Contract(
    name = "contract.MyContract",
    info = @Info(
        title = "MyContract",
        description = "SmartContract vote - Blockchain Workshop",
        version = "1.0.0",
        license = @License(
            name = "Apache 2.0 License",
            url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
        contact = @Contact(
            email = "1421222467@qq.com",
            name = "csren"
	    )
    )
)

@Default
public final class MyContract implements ContractInterface {
    @Transaction(name = "Init", intent = Transaction.TYPE.SUBMIT)
    public void init(final Context ctx) {
        ChaincodeStub stub = ctx.getStub();
        stub.putStringState("userid_voteid", "data");
    }

    @Transaction(name = "CreateVote",intent = Transaction.TYPE.SUBMIT)
    public void createVote(final Context ctx,String voteID,String value){
        ChaincodeStub stub = ctx.getStub();
        stub.putStringState(voteID,value);
    }

    @Transaction(name = "Query", intent = Transaction.TYPE.EVALUATE)
    public String query(final Context ctx,String voteID){
        ChaincodeStub stub = ctx.getStub();
        return stub.getStringState(voteID);
    }
    
    @Transaction(name = "Vote",intent = Transaction.TYPE.SUBMIT)
    public void vote(final Context ctx,String voteID,String name) {
    	ChaincodeStub stub = ctx.getStub();
    	String value = stub.getStringState(voteID);
    	JSONObject jsonObject = JSONObject.parseObject(value);
    	String num = jsonObject.getString(name);
    	int intnum = Integer.parseInt(num);
    	intnum += 1;
    	num = String.valueOf(intnum);
    	jsonObject.put(name,num);
    	String jsonStr = JSONObject.toJSONString(jsonObject);
    	stub.putStringState(voteID,jsonStr);
    }
    
    @Transaction(name = "DeVote",intent = Transaction.TYPE.SUBMIT)
    public void deVote(final Context ctx,String voteID,String name) {
    	ChaincodeStub stub = ctx.getStub();
    	String value = stub.getStringState(voteID);
    	JSONObject jsonObject = JSONObject.parseObject(value);
    	String num = jsonObject.getString(name);
    	int intnum = Integer.parseInt(num);
    	intnum -= 1;
    	num = String.valueOf(intnum);
    	jsonObject.put(name,num);
    	String jsonStr = JSONObject.toJSONString(jsonObject);
    	stub.putStringState(voteID,jsonStr);
    }
}

