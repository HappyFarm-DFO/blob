contract Freebies_1_0_Factory{
    
        uint public code=6;
        
        function install(address happyBox,address priceList)public returns(bool){
            address freeb=address(new Freebies(priceList,happyBox));
            require(MVMCertList(0x38559bF5BCCF08831fFAC85E858BCAfE85609Ba2).setModule(freeb));
            require(HappyBox(happyBox).set(freeb,false,1));
            return true;
        }
        
        function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).master()==msg.sender);
            priceList prices=new priceList(msg.sender);
            address freeb=address(new Freebies(address(prices),happyBox));
            require(Book(0x8FDc27b2F4CC4619f3dCf5170B14E4E854a5032e).setDoor(freeb));
            require(MVMCertList(0x38559bF5BCCF08831fFAC85E858BCAfE85609Ba2).setModule(freeb));
            require(HappyBox(happyBox).set(freeb,false,1));
            return true;
        }
}


contract Freebies {
    
    uint8 public code=7;
    HappyBox public box;
    priceList public prices;
    
    constructor(address _prcs, address _box) public{
        prices=priceList(_prcs);
        box=HappyBox(_box);
    }
    
    function claim(address tkn)public returns(bool){
        require(box.ship(tkn,prices.price(tkn),msg.sender));
        return true;
    } 

  
}
