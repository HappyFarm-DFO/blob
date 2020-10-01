contract Book {

    address[] public doors;
    mapping(address => bool)public isModule;
    address master;
    
    function setDoor(address tkn)public returns(bool){
        require(isModule[msg.sender]||(msg.sender==master));
        doors.push(tkn);
        return true;
    }
    
    
    function setModule(address tkn)public returns(bool){
        require(isModule[msg.sender]||(msg.sender==master));
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
    
}
