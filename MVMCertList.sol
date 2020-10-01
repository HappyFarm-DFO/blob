contract MVMCertList {

    address public master;
    mapping(address => bool)public isFactory;
    mapping(address => bool)public isModule;

    constructor() public {
        master=msg.sender;
    }
    
    function setFactory(address tkn,bool val)public returns(bool){
        require((msg.sender==master)||(isFactory[msg.sender]));
        isFactory[tkn]=val;
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require(isFactory[msg.sender]||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isFactory[msg.sender]));
        master=mstr;
        return true;
    }
    
}
