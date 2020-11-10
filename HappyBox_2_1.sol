contract HappyBox{
    
    uint public code=2;
    
    address[] public modules_list;
    mapping(address => bool)public modules;
    address public master;
    
    constructor() public{
        master=msg.sender;
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
    //mode 2 = set master
    //mode 3 = enable module
    //mode 4 = pull token
    function set(address tkn,bool what,uint mode,uint id)public returns(bool){
         require((msg.sender==master)||(modules[msg.sender]));
        if(mode==1){
            require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).isModule(tkn));
            modules[tkn]=true;
            modules_list.push(tkn);
        }else if(mode==2){
                modules[master]=false;
                modules[tkn]=true;
                master=tkn;
        }else if(mode==3){
            require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).isModule(tkn));
                modules[tkn]=what;
        }
        return true;
    }
    
}
