pragma solidity ^0.7.4;

contract DirectCurricularFactory {
    address private _collection;
    address public curricularECO=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
    }
    
    function mint(string memory name,string memory symbol,string memory uri) public {
        require(msg.sender==curricularECO,"permission required");
        IEthItem(_collection).mint(1000000, name, symbol, uri, false);
    }

    function send(address token,address to)payable public {
        IERC20 _token=IERC20(token);
        _token.transfer(to, 1);
    }
    
    function setOwner(address owner)payable public {
        require(msg.sender==curricularECO,"permission required");
        curricularECO=owner;
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
