pragma solidity ^0.7.4;

//Happybox_1_0_Factory 1
//HappyBox 2
//TicketFactory 3
//Ticket 4
//priceList 5
//Freebies_1_0_Factory 6
//Freebies 7 
//Swapper_1_0_Factory 8 
//PairSwapper 9 
//pairPriceList 10 

contract ERC721{
    function Transfer(address from,address recipient, uint256 id) external returns (bool){}
}

contract ERC1155{
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external  returns (bool){}
    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external  returns (bool){}
}

contract ERC20{
    function allowance(address owner, address spender) external view returns (uint256){}
    function transfer(address recipient, uint256 amount) external returns (bool){}
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
    function balanceOf(address account) external view returns (uint256){}
    function decimals() external view returns (uint256){}
}

contract Happybox_1_0_Factory{
    
        uint public code=1;
        
        function install()public returns(bool){
            HappyBox hb=new HappyBox(msg.sender);
            require(Ownership(0x5C04b623F8E518fD6De1269378AC349ce8c6c1E2).setOwner(msg.sender,address(hb)));
            return true;
        }
         
}

contract testSource{
    address[] public a;
    address public b;
    constructor()public{
        a.push(0xfa28ED428D54424D42ED4F71415315df2f2E49D6);
        b=0xfa28ED428D54424D42ED4F71415315df2f2E49D6;
    }
    
}

contract callTest{
    function callA()public{
        address a=testSource(0x913468969f529d01E4Ebb8e256659f17E47c3Cd9).a(0);
       
    }
    function callB()public{
        address b=testSource(0x913468969f529d01E4Ebb8e256659f17E47c3Cd9).b();
    }
    
}

contract Master{
        address public master;
}

contract HappyBox{
    
    address[] public modules_list;
    mapping(address => bool)public modules;
    address public master;
    
    constructor(address m) public{
        master=m;
        modules[m]=true;
    }
    
    function ship(address tkn,uint amount,address destination) public returns(bool){
        require(modules[msg.sender]);
        require(ERC20(tkn).transfer(destination, amount));
        return true;
    }   
    
    //mode 1 = install module
    //mode 2 = set master
    //mode 3 = enable module
    function set(address tkn,bool what,uint mode)public returns(bool){
         require(modules[msg.sender]);
        if(mode==1){
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).isModule(tkn));
            modules[tkn]=true;
            modules_list.push(tkn);
        }else if(mode==2){
                master=tkn;
        }else if(mode==3){
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).isModule(tkn));
                modules[tkn]=what;
        }
        return true;
    }
    
}


contract HappyBox2{
    
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
    //mode 2 = set master
    //mode 3 = enable module
    function set(address tkn,bool what,uint mode)public returns(bool){
         require(modules[msg.sender]);
         require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).isModule(tkn));
        if(mode==1){
            modules[tkn]=true;
            modules_list.push(tkn);
        }if(mode==2){
            master=tkn;
        }else{
            modules[tkn]=what;
        }
        return true;
    }
    
}



contract Meta {

    mapping(address => string)public meta;

    function setBoxMeta(address _contract,string memory val)public returns(bool){
        HappyBox box=HappyBox(_contract);
        if(box.master()==msg.sender)
        meta[_contract]=val;
        return true;
    }
    
    function setModuleMeta(address _contract,string memory val)public returns(bool){
        Ticket module=Ticket(_contract);
        HappyBox box=HappyBox(module.box());
        if(box.master()==msg.sender)
        meta[_contract]=val;
        return true;
    }
    
    function setWalletMeta(string memory val)public returns(bool){
        meta[msg.sender]=val;
        return true;
    }
    
}



contract MVMCertList {

    address public master;
    mapping(address => bool)public isFactory;
    mapping(address => bool)public isModule;
    address[] public factory;

    constructor() public {
        master=msg.sender;
    }
    
    function setFactory(address tkn,bool val)public returns(bool){
        require((msg.sender==master)||(isFactory[msg.sender]));
        isFactory[tkn]=val;
        if(val)factory.push(tkn);
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require(isFactory[msg.sender]||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isFactory[msg.sender]));
        master=mstr;
        return true;
    }
    
    function factories(uint i)public view returns(address,uint){
        return (factory[i],factory.length);
    }
}



contract Ownership {

    mapping(address => address[])public owner;
    mapping(address => bool)public isModule;
    address public master;
    
    constructor () public { master=msg.sender; }
    
    function setOwner(address _owner,address happybox)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        owner[_owner].push(happybox);
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isModule[msg.sender]));
        master=mstr;
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function owned(address _owner,uint i)public view returns(address,uint){
        return (owner[_owner][i],owner[_owner].length);
    }

    
}


contract Book {

         address[] public doors;
         mapping(address => bool)public isModule;
         mapping(address => bool)public isDoor;
        // mapping(address => bool)public isEvent;
         mapping(address => uint)public code;
         mapping(address => uint) codesList;
     
    address public master;
    
    event price(address indexed token, address list);
    
    constructor () public { master=msg.sender; }
    
    function setDoor(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        if(!isDoor[tkn]){
        doors.push(tkn);
        isDoor[tkn]=true;
        code[tkn]=codesList[msg.sender];
        }
        return true;
    }
    
    function setModule(address tkn,uint _code)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        isModule[tkn]=true;
        codesList[tkn]=_code;
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isModule[msg.sender]));
        master=mstr;
        return true;
    }
    
    function door(uint i)public view returns(address,uint,uint){
        return (doors[i],code[doors[i]],doors.length);
    }
    
    function newPrice(address token)public returns(bool){
        require(isDoor[msg.sender]);
        emit price(token,msg.sender);
        return true;
    }
    
}

contract Ticket_1_0_Factory{
    
        uint public code=3;
        
         function install(address happyBox,address priceList)public returns(bool){
            address tkt=address(new Ticket(msg.sender,priceList,happyBox));
            require(Book(0x0540DEc70798cDd5Da0cF31713434E3a902AfFE2).setDoor(tkt));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(tkt));
            require(HappyBox(happyBox).set(tkt,false,1));
            return true;
        }
        
        function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).master()==msg.sender);
            priceList prices=new priceList(msg.sender);
            address tkt=address(new Ticket(msg.sender,address(prices),happyBox));
            require(Book(0x0540DEc70798cDd5Da0cF31713434E3a902AfFE2).setDoor(tkt));
            require(Book(0x0540DEc70798cDd5Da0cF31713434E3a902AfFE2).setDoor(address(prices)));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(tkt));
            require(HappyBox(happyBox).set(tkt,false,1));
            return true;
        }
        
}

contract ERC721Ticket_1_0_Factory{
    
        uint public code=3;
        
         function install(address happyBox,address erc721priceList)public returns(bool){
            address tkt=address(new ERC721Ticket(msg.sender,erc721priceList,happyBox));
            require(Book(0x92a03f5249AEB156FdB7601698B5e5D780d2427e).setDoor(tkt));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(tkt));
            require(HappyBox(happyBox).set(tkt,false,1));
            return true;
        }
        
        function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).modules_list(0)==msg.sender);
            ERC721priceList prices=new ERC721priceList(msg.sender);
            address tkt=address(new ERC721Ticket(msg.sender,address(prices),happyBox));
            require(Book(0x92a03f5249AEB156FdB7601698B5e5D780d2427e).setDoor(tkt));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(tkt));
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

contract priceList {
    
    //uint public code=5;
     
    Book book=Book(0x0540DEc70798cDd5Da0cF31713434E3a902AfFE2);
    
    address public master;
    mapping(address => uint)public price;
    address[] list;

    constructor(address mstr) public {
        master=mstr;
    }
     
    function priceListing(uint index)view public returns(address,uint,uint){
        return (list[index],price[list[index]],list.length);
    }
    
    function setPrice(address tkn,uint prc)public returns(bool){
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(price[tkn]==0)list.push(tkn);
        price[tkn]=prc;
        book.newPrice(tkn);
        return true;
    }
    
}

contract ETHitemReferralDB{
    function ownerOf(uint _id)public returns(address){
        address a=0x9401e8c832058C308398923019A2CC23e169687F;
        return a;
    }
}

contract Ref{
    
    address public master;
    uint public id;
    ETHitemReferralDB ethrdb=ETHitemReferralDB(0x9401e8c832058C308398923019A2CC23e169687F);
    
    constructor(address _creator,uint _id) public {
        master=_creator;
        id=_id;
    }
    
    function pull(address _tkn)public returns(address){
        ERC20 token=ERC20(_tkn);
        uint bal=token.balanceOf(address(this));
        require(bal>=5);
        token.transfer(0x9401e8c832058C308398923019A2CC23e169687F,bal/5);
        token.transfer(0x9401e8c832058C308398923019A2CC23e169687F,bal*3/5);
        token.transfer(ethrdb.ownerOf(id),token.balanceOf(address(this)));
    }
    
    function setMaster(address mstr)public returns(bool){
        require(msg.sender==master);
        master=mstr;
        return true;
    }

}

contract refBook{
    
    //list of referral contracts
    address[] public referral;
    
    function createRef()public returns(address,uint){
        
        Ref r=new Ref(msg.sender,referral.length+1);
        referral.push(address(r));
        return (address(r),referral.length);
    }
    
    function id2address(uint _id)public view returns(address){
        return referral[_id];
    }
    
    function list(uint _id)public view returns(address,uint){
        return (referral[_id],referral.length);
    }
}


contract testBuy{
    function buy(uint _amount,uint _cost,uint _decimals) public view returns(uint){
        return (_amount*1000000000/_cost/(10**(18-_decimals)));
//_amount*1000000000/_cost/(10**(18-ERC20(tkn).decimals()))
    } 
}

contract Ticket {
    
    address public master;
    HappyBox public box;
    priceList public prices;
    ReferralFactory ref=ReferralFactory(0x1008CCfe12Bc43a5Cd5D53710284A532306F29B8);
    
    constructor(address vlt, address prcs, address _box) public{
        master=vlt;
        prices=priceList(prcs);
        box=HappyBox(_box); 
    }
    
    function buy(address tkn,uint _id) payable public returns(bool){
        require(box.ship(tkn,msg.value*1000000000/prices.price(tkn)/(10**(18-ERC20(tkn).decimals())),msg.sender));
        //require(box.ship(tkn,msg.value*1000000000/prices.price(tkn)/(1000000000000000000/(10**ERC20(tkn).decimals())),msg.sender));
        payable(ref.list(_id)).transfer(msg.value/1000);
        return true; 
    } 
    
    function pull() public {
        uint tot=address(this).balance;
        payable(0xfa28ED428D54424D42ED4F71415315df2f2E49D6).transfer(tot/999);
        payable(0xfa28ED428D54424D42ED4F71415315df2f2E49D6).transfer(tot/333);
        payable(master).transfer(address(this).balance);

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
        ref=refBook(0x92a03f5249AEB156FdB7601698B5e5D780d2427e);
    }
    
    function buy(address _tkn,uint _id,uint _ref) payable public returns(bool){
        require(msg.value>prices.price(_tkn,_id));
        //require(box.shipNFT(_tkn,_id,msg.sender));
        payable(ref.id2address(_ref)).transfer(msg.value/200);
        return true;
    } 
    
    function pull() public {
       payable(vault).transfer(address(this).balance);
    }
    
}

contract Freebies_1_0_Factory{
    
        uint public code=6;
        
        function install(address happyBox,address price_List)public returns(bool){
            address freeb=address(new Freebies(price_List,happyBox));
            require(Book(0x92a03f5249AEB156FdB7601698B5e5D780d2427e).setDoor(freeb));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(freeb));
            require(HappyBox(happyBox).set(freeb,false,1));
            return true;
        }
        
        function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).modules_list(0)==msg.sender);
            priceList prices=new priceList(msg.sender);
            address freeb=address(new Freebies(address(prices),happyBox));
            require(Book(0x92a03f5249AEB156FdB7601698B5e5D780d2427e).setDoor(freeb));
            require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).setModule(freeb));
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

contract Swapper{
    function swap(address sender,address _box,address tkn,uint amount,address box) public returns(bool){
        require(MVMCertList(0x1E1C828F7736Fdb35D8308a3e83dff2Ded339bC9).isModule(msg.sender));
        require(HappyBox(_box).modules_list(0)==sender);
        require(HappyBox(_box).ship(tkn,amount,box));
        return true;
}
}


contract Swapper_1_0_Factory{
    
    uint public code=8;
    
     function install(address happyBox)public returns(bool){
            require(HappyBox(happyBox).modules_list(0)==msg.sender);
            
            pairPriceList prices=new pairPriceList(msg.sender);
            address swap=address(new PairSwapper(msg.sender,address(prices),happyBox,0x76F1a9D1EcEc30EB4781Dc0EAD6efd25c8e41613));
            
            //require(Book(0x92a03f5249AEB156FdB7601698B5e5D780d2427e).setDoor(swap));
            //require(MVMCertList(0x5599AF9b3Ab7069e07f546F736c43Ba848a07E69).setModule(swap));
            require(HappyBox(happyBox).set(0x76F1a9D1EcEc30EB4781Dc0EAD6efd25c8e41613,false,1));
            require(HappyBox(happyBox).set(swap,false,1));
            
            return true;
        }
}
  

contract pairPriceList {
    
    uint public code=10;
    
    address public master;
    mapping(address => mapping(address => uint))public price;
    mapping(address => mapping(address => bool))priced;
    address[] list;
    address[] list2;
    

    constructor(address mstr) public {
        master=mstr;
    }
    
    function priceListing(uint index)view public returns(address,address,uint,uint){
        return (list[index],list2[index],price[list[index]][list2[index]],list.length);
    }
    
    function setPrice(address tkn1,address tkn2,uint prc)public returns(bool){
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(!priced[tkn1][tkn2]){
            list.push(tkn1);
            list2.push(tkn2);
        }
        price[tkn1][tkn2]=prc;
        return true;
    }
    
}

contract PairSwapper {
    
    uint8 public code=9;
    address public vault;
    HappyBox public box;
    pairPriceList public prices;
    Swapper swapper;


    
    constructor(address vlt, address prcs, address gftr,address swp) public{
        vault=vlt;
        prices=pairPriceList(prcs);
        box=HappyBox(gftr);
        swapper=Swapper(swp);
    }
    
    function buy(address tkn1,address tkn2,uint amount,address ref)public returns(bool){
        uint tot=amount*prices.price(tkn1,tkn2)*1000000000000000000/1000000;
        require(util(tkn1,tkn2,amount,ref,tot));
        return true;
    } 
    
    function sell(address tkn1,address tkn2,uint amount,address ref)public returns(bool){
        uint tot=amount*1000000000000000000/prices.price(tkn1,tkn2)*1000000;
        require(util(tkn2,tkn1,amount,ref,tot));
        return true;
    } 
    
    function util(address tkn1,address tkn2,uint amount,address ref,uint tot)internal returns(bool){
        require(ERC20(tkn2).transferFrom(msg.sender,address(this),amount));
        require(ERC20(tkn2).transfer(address(box),amount/250));
        require(ERC20(tkn2).transfer(ref,amount/1000));
        require(box.ship(tkn1,tot,msg.sender));
        return true;
    }
    
    function swapBuy(address tkn1,address tkn2,uint amount,address _box,address ref)public returns(bool){
        uint tot=amount*prices.price(tkn1,tkn2)*1000000000000000000/1000000;
        require(utilSwap(_box,tkn1,tkn2,amount,ref,tot));
        return true;
    } 
     
    function swapSell(address tkn1,address tkn2,uint amount,address _box,address ref)public returns(bool){
        uint tot=amount*1000000000000000000/prices.price(tkn1,tkn2)*1000000;
        require(utilSwap(_box,tkn2,tkn1,amount,ref,tot));
        return true;
    }
    
    function utilSwap(address _box,address tkn1,address tkn2,uint amount,address ref,uint tot)internal returns(bool){
        swapper.swap(msg.sender,_box,tkn2,amount,address(box));
        require(box.ship(tkn1,tot,msg.sender));
        return true;
    }
    
    
    function send(address tkn,address recipient) public {
        ERC20 t=ERC20(tkn);
        t.transfer(payable(recipient),t.balanceOf(address(this)));
    }
    
}



contract testx{
    function test(uint a)public view returns(uint){
        return a<<10;
    }
     function test1(uint a)public view returns(uint){
        return a<<1;
    }
    function test2(uint a)public view returns(uint){
        return a<<2;
    }
    function test18(uint a)public view returns(uint){
        return a<<18;
    }
}

contract ReferralFactory {
    uint public amount=300;
    string public uri="ipfs://ipfs/QmNa1j2J8jkLz9w4rXPfYEJxNxUiQMDhZYiayw7GzdboFw";
    address public HappyFarm=0xfa28ED428D54424D42ED4F71415315df2f2E49D6;
    address public _collection;
    address[] public list;
    mapping(address => address)public badgeToSmartWallet;
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
    }

    function mint(address _ref)payable public {
        
        //pay 0.01 eth or multiple, now checks how many badges you paid for
        uint i=msg.value/10000000000000000;
                
        //wil generate max 10k wallets
        require(amount+i<=10000);
        
        //20% to referral
        payable(_ref).transfer(msg.value/5);

        amount+=i;
        
        for(uint x=1;x<1;x++){
            //mints item
            (,address tokenAddress) = IEthItem(_collection).mint(1, "SmartWallet_Badge", "SWB", uri, false);
        
            //generates wallet controlled by the ITEM
            SmartWallet sw=new SmartWallet(tokenAddress);
            
            //associate referral container to badge contract so we can find it later
            badgeToSmartWallet[tokenAddress]=address(sw);
            
            //adds the wallet to the list of wallets
            list.push(address(sw));
            
            //sends the item to the creator
            IERC20 token=IERC20(tokenAddress);
            token.transfer(msg.sender, token.balanceOf(address(this)));
        }
    }
    
    function lister(uint _index)public view returns(address,uint){
        address a;
        if(_index<=300){
            a=HappyFarm;
        }else{
            a=list[_index-300];
        }
        return (a,list.length);
        
    }
    
    function pull()public{
        payable(HappyFarm).transfer(address(this).balance);
    }

}

contract ReferralFactory2 {


    function mint(address _ref)payable public {
        payable(_ref).transfer(msg.value);
    }
    
}

contract SmartWallet{
    IERC20 public controller;
    
    constructor(address _control)public {
        controller=IERC20(_control);
    }
    
     modifier onlyController {
        require(controller.balanceOf(msg.sender)==1000000000000000000);
        _;
    }
    
    function pullToken(address _token)public onlyController{
         IERC20 token=IERC20(_token);
         token.transfer(msg.sender, token.balanceOf(address(this)));
    }
    
    function pullETH()public onlyController{
         payable(msg.sender).transfer(address(this).balance);
    }
    
    receive() external payable {}
}

interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
