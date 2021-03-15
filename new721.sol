pragma solidity ^0.6.2;


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
        CypherShop1155=contr;
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
