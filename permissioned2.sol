pragma solidity ^0.7.4;

contract DirectCurricularFactory {
    address public _collection;
    address public curricularECO;
    mapping(address =>  bool)public isAllowed;
    mapping(uint8 =>  address)public trigger;
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        curricularECO = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    }
    
    function mint(string memory name,string memory symbol,string memory uri) public {
        require(msg.sender==curricularECO,"permission required");
        IEthItem(_collection).mint(1000000, name, symbol, uri, false);
    }

    function claim(uint8 curriculum,address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(trigger[curriculum]).transfer(to, 1000000000000000000);
    }
    
    function setOwner(address owner)public {
        require(msg.sender==curricularECO,"permission required");
        curricularECO=owner;
    }
    
    function setPermission(address trigg,address curriculum,bool b,uint8 index)public returns(bool){
        require(msg.sender==curricularECO,"permission required");
        isAllowed[trigg]=b;
        return true;
    }
    
    function setTrigger(address trigg,uint8 index)public returns(bool){
        require(msg.sender==curricularECO,"permission required");
        trigger[index]=trigg;
        return true;
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
