pragma solidity ^0.7.4;

contract CypherVaultFactory {
    address public _collection;
    address public CypherVault;
    address public Curricular;
    address public CypherShop;
    mapping(bytes => address[])public tags;

    event ncx(address indexed who,address cx);
    event cxtag(bytes indexed tag1,bytes indexed tag2,bytes indexed tag3,address cx);
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        CypherVault = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
        Curricular = 0xC7084B1aDa5C797A5549CCa4727A2B5A84958775;
        CypherShop = 0x3f197658886B995B4960d2882E2e025fCAA7df86;
    }
    
    function mintSetPrice(string memory name,string memory symbol,string memory uri,bytes memory tag1,bytes memory tag2,bytes memory tag3,uint256 price) public {
        (,address tokenAddress)=IEthItem(_collection).mint(1, name, symbol, uri, false);
        ICypherShop(CypherShop).setPrice(msg.sender,tokenAddress,price);
        IERC20(tokenAddress).transfer(CypherShop, 1000000000000000000);
        emit cxtag(tag1,tag2,tag3,tokenAddress);
        emit ncx(msg.sender,tokenAddress);
        ICurricular(Curricular).claim(msg.sender,1);
    }
    
    function mintSend(string memory name,string memory symbol,string memory uri,bytes memory tag1,bytes memory tag2,bytes memory tag3,address to) public {
        (,address tokenAddress)=IEthItem(_collection).mint(1, name, symbol, uri, false);
        IERC20(tokenAddress).transfer(to, 1000000000000000000);
        emit cxtag(tag1,tag2,tag3,tokenAddress);
        emit ncx(msg.sender,tokenAddress);
        ICurricular(Curricular).claim(msg.sender,1);
    }
    
    
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCurricular(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        Curricular=contr;
    }
    
    function setCypherShop(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherShop=contr;
    }
    
}

contract ICypherShop{
    mapping(address => uint256)public prices;
    mapping(address => address payable)public creators;
    event scx(address cx);
        
    function buy(address token)public payable returns(bool){
        require(msg.value>prices[token],"more honey!");
        require(IERC20(token).transfer(msg.sender, 1000000000000000000),"wtf?");
        creators[token].transfer(msg.value);
        emit scx(token);
    }
    
    function setPrice(address payable author,address t,uint256 p) external{
        require(msg.sender==CypherVaultFactory,"permission required");
        prices[t]=p;
        creators[t]=author;
    }
    
    function changePrice(address t,uint256 p) external{
        require(msg.sender==creators[t],"permission required");
        prices[t]=p;
    }
    
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    address public CypherVaultFactory=0xB69955E700803Ba545371459e48370aB0A9c1D2D;
    
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory=factory;
    }
    

}

contract ICurricular {
    function claim(address to, uint256 typ)public {
        
    }
}

interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
