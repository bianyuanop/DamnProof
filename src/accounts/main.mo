import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import RBTree "mo:base/RBTree";
import Principal "mo:base/Principal";
import Error "mo:base/Error";


actor AccountService {
    class Account(_identity: Principal) {
    public var identity = _identity;
    public var profileURI : Text = "";
    public var registerDate : Time.Time = Time.now();

    public func updateProfileURI(addr: Text) : async [Bool] {
        profileURI := addr;
        [true]
    };

    public func getProfileURI(): async [Text] {
        [profileURI]
    };
    }; 

  var accounts = RBTree.RBTree<Principal, Account>(Principal.compare);

  // Say the given phase.
  public query func getCount() : async (Nat) {
      // TODO: haven't figure out how the usage of RBTree.size
      // RBTree.size<Principal, Account>(accounts);
      0
  };

  public shared({caller}) func register() : async [Bool] {
    var account = Account(caller);
    accounts.put(caller, account);
    [true]
  };

  public query func verify(prcpl: Principal) : async [Bool] {
    let accountOp = accounts.get(prcpl);
    let res = switch accountOp {
      case null false;
      case (?acc) true;
    };
    [res]
  };

  public shared({caller}) func updateProfileURI(_URI: Text) : async [Bool] {
    let accountOp = accounts.get(caller);
    var res: [Bool] = await verify(caller);
    if(res[0] == false) {
        [false]
    } else {
        let account = switch accountOp {
            case (?acc) acc;
            case null Account(caller);
        };
        await account.updateProfileURI(_URI);
    }
  };
};