contract Happybox_1_0_Factory{
    
        uint public code=1;
        
        function install()public returns(bool){
            HappyBox hb=new HappyBox(msg.sender);
            require(Ownership(0x922619519532b40eAc430492aaDB6BC157eba2b4).setOwner(msg.sender,address(hb)));
            return true;
        }
        
}

contract Master{
        address public master;
}

contract HappyBox{
    
    uint public code=2;
    
    address[] public modules_list;
    mapping(address => bool)public modules;
    address public master;
    
    constructor(address mstr) public{
        master=mstr;
        modules[mstr]=true;
    }
    
    function ship(address tkn,uint amount,address destination) public returns(bool){
        require(modules[msg.sender]);
        require(ERC20(tkn).transfer(destination, amount));
        return true;
    }   
    
    function shipNFT(address tkn,uint id,address destination) public returns(bool){
        require(modules[msg.sender]);
        require(ERC721(tkn).Transfer(address(this),destination, id));
        return true;
    } 
    
    function ship1155(address tkn,uint _id,address _to,uint amount,bytes memory _data) public returns(bool){
        require(modules[msg.sender]);
        require(ERC1155(tkn).safeTransferFrom(address(this),_to,_id,amount,_data));
        return true;
    } 
    
    function shipbatch1155(address tkn, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) public returns(bool){
        require(modules[msg.sender]);
        require(ERC1155(tkn).safeBatchTransferFrom(address(this),_to,_ids,_values,_data));
        return true;
    } 
    
    //mode 1 = install module
    //mode 3 = enable module
    function set(address tkn,bool what,uint mode)public returns(bool){
         require(modules[msg.sender]);
         require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).isModule(tkn));
        if(mode==1){
            modules[tkn]=true;
            modules_list.push(tkn);
        }else{
            modules[tkn]=what;
        }
        return true;
    }
    
}
