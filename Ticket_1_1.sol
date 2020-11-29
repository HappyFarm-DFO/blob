contract Ticket {
    
    //uint8 public code=4;
    address public master;
    HappyBox public box;
    priceList public prices;
    refBook ref=refBook(0x9401e8c832058C308398923019A2CC23e169687F);
    
    constructor(address vlt, address prcs, address _box) public{
        master=vlt;
        prices=priceList(prcs);
        box=HappyBox(_box); 
    }
    
    function buy(address tkn,uint _id) payable public returns(bool){
        require(box.ship(tkn,msg.value*1000000000/prices.price(tkn)/(10**(18-ERC20(tkn).decimals())),msg.sender));
        payable(ref.list(_id)).transfer(msg.value/250);
        return true; 
    } 
    
    function pull() public {
        uint tot=address(this).balance;
        payable(0xfa28ED428D54424D42ED4F71415315df2f2E49D6).transfer(tot/500);
        payable(0xfa28ED428D54424D42ED4F71415315df2f2E49D6).transfer(tot/500*3);
        payable(master).transfer(address(this).balance);

    }
    
}
