pragma solidity ^0.7.4;

contract ShitFactory {
    address private _collection;
    address public curricularECO;
    string public uri="ipfs metada file address";
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
    }
    
    function mint(string name,string symbol,string uri) public {
        require(msg.sender==curricularECO,"permission required");
        (,address tokenAddress) = IEthItem(_collection).mint(1000000000000, name, symbol, uri, false);
    }

    function send(address token,address to)payable public {
        IERC20 token=IERC20(token);
        token.transfer(to, 1));
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
