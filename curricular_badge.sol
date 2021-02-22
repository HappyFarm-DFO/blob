pragma solidity ^0.7.4;

contract ShitFactory {
    address private _collection;
    uint public amount=0;
    string public uri="ipfs metada file address";
    address[] public list;
    
    function init() public {
        require(_collection == address(0), "Init already called!");
        _collection = msg.sender;
    }

    function mint()payable public {
        (,address tokenAddress) = IEthItem(_collection).mint(1, "Shit", "SHT", uri, false);
        IERC20 token=IERC20(tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

}


interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
} 
