pragma solidity ^0.6.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC721/ERC721.sol";

contract Factory is ERC721 {
    uint256 public index;

    constructor() public ERC721("GameItem", "ITM") {}
    
    address public CypherVault = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    address public Curricular = 0x5e767a6C282f26DE3133D5C4B7305ea2d5cB5A1B;
    address public CypherShop721 = 0xa3eBfAAe3Dd81A79F592c601618F55B46d4502e0;
    
    event ncx(address indexed who,address cx,uint256 id);
     
    function setCurricular(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        Curricular=contr;
    }
    
    function setCypherShop(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherShop721=contr;
    }
    
    function setOwner(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=contr;
    }

    function mintSetPrice(address operator,string memory uri,uint256 price) public returns(bool){
        index=index++;
        _mint(CypherShop721, index);
        _setTokenURI(index, uri);
         emit ncx(operator,address(this),index);
        ICurricular(Curricular).claim(operator);
        return true;
    }
    
    function mintSend(address operator,string memory name,string memory symbol,uint256 amount,string memory uri,address to) public returns(bool){
        index=index++;
        _mint(to, index);
        _setTokenURI(index, uri);
         emit ncx(operator,address(this),index);
        ICurricular(Curricular).claim(operator);
        return true;
    }
}

contract ICurricular {
    function claim(address to)public {}
}

contract ICypherShop721{
    mapping(address => mapping(uint256 => uint256))public prices;
    mapping(address => mapping(uint256 => address payable))public creators;
    event scx(address cx);
        
    function buy(address token,uint256 id)public payable returns(bool){
        require(msg.value>=prices[token][id],"more honey!");
        creators[token][id].transfer(msg.value);
        Factory(token).Transfer(address(this), msg.sender,id);
        emit scx(token);
        return true;
    }
    
    function setPrice(address payable author,address t,uint256 id,uint256 p) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[t][id]=p;
        creators[t][id]=author;
    }
    
    function changePrice(address t,uint256 id,uint256 p) external{
        require(msg.sender==creators[t][id],"permission required");
        prices[t][id]=p;
    }
    
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
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
