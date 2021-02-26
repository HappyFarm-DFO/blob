pragma solidity ^0.7.4;

contract DirectCurricularFactory {
    address public _collection;
    address public curricularECO;
    mapping(bytes => address[])public tags;
    event ncx(address indexed who,address cx);
    event cx(address indexed who,address cx);
    event cxtag(bytes indexed tag1,bytes indexed tag2,bytes indexed tag3,address cx);
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        curricularECO = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    }
    
    function mint(string memory name,string memory symbol,string memory uri) public {
        require(msg.sender==curricularECO,"permission required");
        (,address tokenAddress)=IEthItem(_collection).mint(1000000, name, symbol, uri, false);
        emit ncx(msg.sender,tokenAddress);
    }
    
    function mintSoftIndex(string memory name,string memory symbol,string memory uri,bytes memory tag1,bytes memory tag2,bytes memory tag3) public {
        require(msg.sender==curricularECO,"permission required");
        (,address tokenAddress)=IEthItem(_collection).mint(1000000, name, symbol, uri, false);
        emit cxtag(tag1,tag2,tag3,tokenAddress);
        emit ncx(msg.sender,tokenAddress);
    }
    
    function mintStrongIndex(string memory name,string memory symbol,string memory uri,bytes memory tag1,bytes memory tag2,bytes memory tag3) public {
        require(msg.sender==curricularECO,"permission required");
        (,address tokenAddress)=IEthItem(_collection).mint(1000000, name, symbol, uri, false);
        if(tag1.length>0)tags[tag1].push(tokenAddress);
        if(tag2.length>0)tags[tag2].push(tokenAddress);
        if(tag3.length>0)tags[tag3].push(tokenAddress);
        emit ncx(msg.sender,tokenAddress);
    }

    function send(address token,address to)payable public {
        IERC20(token).transfer(to, 1000000000000000000);
        emit cx(to,token);
    }
    
    function setOwner(address owner)payable public {
        require(msg.sender==curricularECO,"permission required");
        curricularECO=owner;
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
