contract ERC721Ticket_1_0_Factory{
    
        uint public code=3;
        
         function install(address happyBox,address erc721priceList)public returns(bool){
            address tkt=address(new ERC721Ticket(msg.sender,erc721priceList,happyBox));
            require(Book(0xFb7016056c83b93403df9c479c5D8a75ed3F71E2).setDoor(tkt));
            require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).setModule(tkt));
            require(HappyBox(happyBox).set(tkt,false,1));
            return true;
        }
        
        function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).master()==msg.sender);
            ERC721priceList prices=new ERC721priceList(msg.sender);
            address tkt=address(new ERC721Ticket(msg.sender,address(prices),happyBox));
            require(Book(0xFb7016056c83b93403df9c479c5D8a75ed3F71E2).setDoor(tkt));
            require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).setModule(tkt));
            require(HappyBox(happyBox).set(tkt,false,1));
            return true;
        }
        
}

contract ERC721priceList {
    
    uint public code=5;
    
    event priceSet(address token,uint id);
    
    address public master;
    mapping(address =>  mapping(uint => uint))public price;
    address[] list;
    uint[] idlist;

    constructor(address mstr) public {
        master=mstr;
    }
    
    function priceListing(uint index)view public returns(address,uint,uint,uint){
        return (list[index],idlist[index],price[list[index]][idlist[index]],list.length);
    }
    
    function setPrice(address tkn,uint id,uint prc)public returns(bool){
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(price[tkn][id]==0)list.push(tkn);
        price[tkn][id]=prc;
        emit priceSet(tkn,id);
        return true;
    }
    
}


contract ERC721Ticket {
    
    uint8 public code=4;
    address public vault;
    HappyBox public box;
    ERC721priceList public prices;
    refBook ref;
    
    constructor(address vlt, address prcs, address gftr) public{
        vault=vlt;
        prices=ERC721priceList(prcs);
        box=HappyBox(gftr); 
        ref=refBook(0x9401e8c832058C308398923019A2CC23e169687F);
    }
    
    function buy(address _tkn,uint _id,uint _ref) payable public returns(bool){
        require(msg.value>prices.price(_tkn,_id));
        require(box.shipNFT(_tkn,_id,msg.sender));
        payable(ref.id2address(_ref)).transfer(msg.value/200);
        return true;
    } 
    
    function pull() public {
       payable(vault).transfer(address(this).balance);
    }
    
}
