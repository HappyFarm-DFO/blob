contract Book {

    address[] public doors;
    mapping(address => bool)public isModule;
    mapping(address => bool)public isDoor;
    address public master;
    
    event price(address indexed token, address list);
    
    constructor () public { master=msg.sender; }
    
    function setDoor(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        if(!isDoor[tkn]){
        doors.push(tkn);
        isDoor[tkn]=true;
        }
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isModule[msg.sender]));
        master=mstr;
        return true;
    }
    
    function door(uint i)public view returns(address,uint){
        return (doors[i],doors.length);
    }
    
    function newPrice(address token)public returns(bool){
        require(isDoor[msg.sender]);
        emit price(token,msg.sender);
        return true;
    }
    
}
