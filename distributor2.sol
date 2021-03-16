pragma solidity ^0.7.4;

contract CypherVaultFactory {
    address public _collection;
    address public CypherVault;
    address public Curricular;
    address public CypherShop;
    event ncx(address indexed who,address cx,uint256 id);
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        CypherVault = 0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
        Curricular = 0x3a326C47D7471B87360661Cc8Ad070AB87C87756;
        CypherShop = 0xc1302620B15B109fd15Fe2D9201B20145323db2B;
    }
    
    function mintSetPrice(address operator,string memory name,string memory symbol,uint256 amount,string memory uri,uint256 price) public returns(bool){
        (,address tokenAddress)=IEthItem(_collection).mint(amount, name, symbol, uri, false);
        ICypherShop(CypherShop).setPrice(payable(operator),tokenAddress,price);
        IERC20(tokenAddress).transfer(CypherShop, 1000000000000000000*amount);
        emit ncx(operator,tokenAddress,0);
        //DirectCurricularFactory(Curricular).claim1(operator);
        return true;
    }
    
    function mintSend(address operator,string memory name,string memory symbol,uint256 amount,string memory uri,address to) public {
        (,address tokenAddress)=IEthItem(_collection).mint(amount, name, symbol, uri, false);
        IERC20(tokenAddress).transfer(to, 1000000000000000000*amount);
        emit ncx(operator,tokenAddress,0);
        //DirectCurricularFactory(Curricular).claim1(operator);
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

contract equityDistributor2 {
    address public equities=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
      
      function setEquities(address contr)public{
        require(msg.sender==CypherVault,"permission required");
        equities=contr;
    }
    
        
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    
    function mintSetPrice(address vault,string memory name,string memory symbol,uint256 amount,string memory uri,uint256 price) public {
        require(CypherVaultFactory(vault).mintSetPrice(msg.sender,name,symbol,amount,uri,price),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}

contract ICypherShop{
    mapping(address => uint256)public prices;
    mapping(address => address payable)public creators;
    event scx(address cx);
        
    function buy(address token)public payable returns(bool){
        require(msg.value>=prices[token],"more honey!");
        creators[token].transfer(msg.value);
        require(IERC20(token).transfer(msg.sender, msg.value/prices[token]*1000000000000000000),"wtf?");
        emit scx(token);
        return true;
    }
    
    function setPrice(address payable author,address t,uint256 p) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[t]=p;
        creators[t]=author;
    }
    
    function changePrice(address t,uint256 p) external{
        require(msg.sender==creators[t],"permission required");
        prices[t]=p;
    }
    
    address public CypherVault=0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
    mapping(address => bool) public CypherVaultFactory;
    
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory[factory]=b;
    }
    

}

contract Emitter {
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    mapping(address => bool) public CypherVaultFactory;
    event ncx(address indexed who,address cx,uint256 id);
    
    //for erc1155
    function emit1155(address from,uint256 id)public {
        require(CypherVaultFactory[msg.sender],"permission required");
        emit ncx(from,msg.sender,id);
    }
    
    
    //for items
    function emitItem(address from,address token)public {
        require(CypherVaultFactory[msg.sender],"permission required");
        emit ncx(from,token,0);
    }
    
     function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory[factory]=b;
    }
}


contract equityDistributor {
    address public equities=0x11948B6F6Eaa780f8166B1b76a2892Ff756967f0;
    address public CypherVault=0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
    mapping(address => bool)public vaults;
      
      function setEquities(address contr)public{
        require(msg.sender==CypherVault,"permission required");
        equities=contr;
    }
    
        
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setVault(address vault,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        vaults[vault]=b;
    }
    
    
    function mintSetPrice(address vault,string memory name,string memory symbol,uint256 amount,string memory uri,uint256 price) public {
        require(vaults[vault],"wrong vault");
        require(CypherVaultFactory(vault).mintSetPrice(msg.sender,name,symbol,amount,uri,price),"something wrong");
        //require(Factory(vault).mintSetPrice(msg.sender,uri,price),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}



interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 


contract DirectCurricularFactory {
    function claim1(address to)public {}
}
