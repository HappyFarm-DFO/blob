contract Ownership {

    mapping(address => address[])public owner;
    mapping(address => bool)public isModule;
    address public master;
    
    constructor () public { master=msg.sender; }
    
    function setOwner(address _owner,address happybox)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        owner[_owner].push(happybox);
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isModule[msg.sender]));
        master=mstr;
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function owned(address _owner,uint i)public view returns(address,uint){
        return (owner[_owner][i],owner[_owner].length);
    }

    
}
