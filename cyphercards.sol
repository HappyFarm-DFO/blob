pragma solidity ^0.7.4;

contract CypherVaultFactory {
    address public _collection;
    address public Dev;
    address public Curator;
    address public Curricular;
    address public CypherShop;
    event ncx(address indexed who,address cx,uint256 id);
    buffer[]public waiting;
    mapping(uint256 => bool)public curatorClaim; 
    mapping(uint256 => bool)public artistClaim; 
    
    struct buffer{
        address author;
        string name;
        string symbol;
        uint256 amount;
        string uri;
    }
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        Dev = 0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
        Curricular = 0x3a326C47D7471B87360661Cc8Ad070AB87C87756;
        CypherShop= 0xEd612b8f32B55544581Ec22274b80D87bf96D32b;
        Curator = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    }
    
    function mintSetPrice(uint256 id,string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
         require(msg.sender==Curator,"permission required");
        buffer memory buf= waiting[id];
        (,address tokenAddress)=IEthItem(_collection).mint(100, buf.name, buf.symbol, buf.uri, false);
        ICypherCardShop(CypherShop).setPrice(payable(Curator),payable(buf.author),tokenAddress);
        IERC20 t=IERC20(tokenAddress);
        t.transfer(CypherShop, 94000000000000000000);
        t.transfer(Curator, 2000000000000000000);
        t.transfer(Dev, 1000000000000000000);
        emit ncx(buf.author,tokenAddress,0);
        //DirectCurricularFactory(Curricular).claim1(operator);
        return true;
    }
    
        function mintNow(string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
         require(msg.sender==Curator,"permission required");
        (,address tokenAddress)=IEthItem(_collection).mint(100, name, symbol, uri, false);
        ICypherCardShop(CypherShop).setPrice(payable(Curator),payable(Curator),tokenAddress);
        IERC20(tokenAddress).transfer(CypherShop, 100000000000000000000);
        emit ncx(Curator,tokenAddress,0);
        //DirectCurricularFactory(Curricular).claim1(operator);
        return true;
    }
    
    
    function submitCard(string memory name,string memory symbol,uint256 amount,string memory uri)public returns(bool){
        waiting.push(buffer(msg.sender,name,symbol,amount,uri));
        return true;
    }
    
  
    
    
    function setCurator(address curator)payable public {
        require(msg.sender==Curator,"permission required");
        Curator=curator;
    }
    
    function setCurricular(address contr)payable public {
        require(msg.sender==Curator,"permission required");
        Curricular=contr;
    }
    
    function setCypherShop(address contr)payable public {
        require(msg.sender==Curator,"permission required");
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
        //require(CypherVaultFactory(vault).mintSetPrice(msg.sender,name,symbol,amount,uri,price),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}

contract ICypherCardShop{
    mapping(address => uint256)public prices;
    mapping(address => address payable)public creators;
    mapping(address => address payable)public curators;
    event scx(address cx);
    uint256 public shopType=2;
        
    function buy(address token,uint256 amount)public payable returns(bool){
        prices[token]+=amount*100000000000000000;
        require(msg.value>=prices[token]*amount,"more honey!");
        creators[token].transfer(msg.value/3);
        curators[token].transfer(msg.value/3);
        CypherVault.transfer(msg.value-(msg.value/3*2));
        require(IERC20(token).transfer(msg.sender, 1000000000000000000*amount),"wtf?");
        emit scx(token);
        return true;
    }
    
    function setPrice(address payable curator,address payable author,address t) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[t]=10000000000000000;
        curators[t]=curator;
        creators[t]=author;
    }
    
    function changePrice(address t,uint256 p) external{
        require(msg.sender==creators[t],"permission required");
        prices[t]=p;
    }
    
    address payable public CypherVault=0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
    mapping(address => bool) public CypherVaultFactory;
    
    function setOwner(address payable owner)payable public {
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
        //require(CypherVaultFactory(vault).mintSetPrice(msg.sender,name,symbol,amount,uri,price),"something wrong");
        //require(Factory(vault).mintSetPrice(msg.sender,uri,price),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}



interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function extension() view external returns(address);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 


contract DirectCurricularFactory {
    function claim1(address to)public {}
}
