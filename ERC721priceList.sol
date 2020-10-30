contract ERC721priceList {
    
    uint public code=5;
    
    event priceSet(address token,uint id);
    
    address public master;
    mapping(address =>  mapping(uint => uint))public price;
    address[] list;
    address[] idlist;

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
