contract DirectCurricularFactory {
    address public _collection;
    address public curricularECO;
    address public curriculum1;
    address public curriculum2;
    address public curriculum3;
    address public curriculum4;
    address public curriculum5;
    address public curriculum6;
    address public curriculum7;
    address public curriculum8;
    mapping(address =>  bool)public isAllowed;
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
        curricularECO = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    }
    
    function mint(string memory name,string memory symbol,string memory uri) public {
        require(msg.sender==curricularECO,"permission required");
        IEthItem(_collection).mint(1000000, name, symbol, uri, false);
    }

    function claim1(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum1).transfer(to, 1000000000000000000);
    }
    function claim2(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum2).transfer(to, 1000000000000000000);
    }
    function claim3(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum3).transfer(to, 1000000000000000000);
    }
    function claim4(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum4).transfer(to, 1000000000000000000);
    }
    function claim5(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum5).transfer(to, 1000000000000000000);
    }
    function claim6(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum6).transfer(to, 1000000000000000000);
    }
    function claim7(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum7).transfer(to, 1000000000000000000);
    }
    function claim8(address to)public {
        require(isAllowed[msg.sender],"permission required");
        IERC20(curriculum8).transfer(to, 1000000000000000000);
    }
    
    function setOwner(address owner)public {
        require(msg.sender==curricularECO,"permission required");
        curricularECO=owner;
    }
    
    function setPermission(address trigg,bool b)public returns(bool){
        require(msg.sender==curricularECO,"permission required");
        isAllowed[trigg]=b;
        return true;
    }
    
    function setTrigger(address trigg,uint8 index)public returns(bool){
        require(msg.sender==curricularECO,"permission required");
        if(index==1)curriculum1=trigg;
        if(index==2)curriculum2=trigg;
        if(index==3)curriculum3=trigg;
        if(index==4)curriculum4=trigg;
        if(index==5)curriculum5=trigg;
        if(index==6)curriculum6=trigg;
        if(index==7)curriculum7=trigg;
        if(index==8)curriculum8=trigg;
        return true;
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
