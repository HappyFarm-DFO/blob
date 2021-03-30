pragma solidity ^0.6.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC721/ERC721.sol";

contract Factory is ERC721 {
    uint256 public index;
    mapping(address => bool)public permissioned;
    mapping(uint256 => bool)public locked;
    address[] public permissionedList;
    mapping(uint256 => link[])public folder;
    mapping(uint256 => address)public folderPermissioned;
    
    struct link{
        bool nft;
        address vault;
        uint256 id;
    }

    constructor() public ERC721("LIPS PAGE FACTORY 1.0","LIPSp"){
        permissioned[0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0]=true;
        permissionedList.push(0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0);
    }
    

    address public Curricular = 0x7938f3D7c0bE34b96C281B6fe591127BBC07CbDE;
    event ncx(address indexed who,address cx,uint256 id);
     
    function setCurricular(address contr)payable public {
        require(permissioned[msg.sender],"permission required");
        Curricular=contr;
    }
    

    function setPermissioned(address contr,bool b)public {
        require(permissioned[msg.sender],"permission required");
        permissioned[contr]=b;
    }
    
    function setFolderPermissioned(address user,uint256 id)public {
        require(folderPermissioned[id]==msg.sender,"permission required");
        folderPermissioned[id]=user;
    }
    
    function addFolder(bool nft,address vault,uint256 id)public {
        require(folderPermissioned[id]==msg.sender,"permission required");
        folder[id].push(link(nft,vault,id));
    }
    
    function removeFolder(uint256 id,uint256 index)public {
        require(folderPermissioned[id]==msg.sender,"permission required");
        if(folder[id].length>1){
        folder[id]=folder[folder[id].length-1];
        delete folder[folder[id].length-1];
        }else{
        delete folder[0];
        }
    }

    
    function mintSend(address operator,string memory uri,address to) public returns(bool){
        index++;
        _mint(to, index);
        _setTokenURI(index, uri);
         emit ncx(operator,address(this),index);
        ICurricular(Curricular).claim1(operator);
        folderPermissioned[index]=operator;
        return true;
    }
    
    function setMeta(uint256 id,string memory uri)public returns(bool){
        require(msg.sender==ownerOf(id),"not your lips page");
        require(!locked[id],"lips page locked");
        _setTokenURI(id, uri);
        return true;
    }
    
    function lock(uint256 id)public returns(bool){
        require(msg.sender==ownerOf(id),"not your lips page");
        locked[id]=true;
        return true;
    }
}

contract ICurricular {
    function claim1(address to)public {}
}

contract IEthItem{
    function transfer(address to,uint256 amount)public {}
}




contract equityDistributorLIPS {
    address public equities=0x11948B6F6Eaa780f8166B1b76a2892Ff756967f0;
    address public CypherVault=0xF0899D85eD919Cf02Ea7243e47c2D4834Bc6dda0;
      
      function setEquities(address contr)public{
        require(msg.sender==CypherVault,"permission required");
        equities=contr;
    }
    
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    
    function mintSend(address vault,string memory uri) public {
        require(Factory(vault).mintSend(msg.sender,uri,msg.sender),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}
