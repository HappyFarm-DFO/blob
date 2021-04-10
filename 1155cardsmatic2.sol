// SPDX-License-Identifier: MIT

pragma  experimental ABIEncoderV2;


import "./IERC1155.sol";
import "./IERC1155MetadataURI.sol";
import "./IERC1155Receiver.sol";
import "../../GSN/Context.sol";
import "../../introspection/ERC165.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";

/**
 *
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
 
contract tracker {
    

    struct nft {
        address cx;
        uint256 id;
    }
  
    mapping(address => nft[]) public ownedList;
    
     mapping(address => mapping(address => mapping(uint256 => bool))) public owned;
    
    function track(address operator,address cx,uint256 id)public{
         require(CypherVaultFactory[msg.sender],"permission required");
         if(!owned[operator][cx][id]){
         owned[operator][cx][id]=true;
         ownedList[operator].push(nft(cx,id));
         if(operator!=Dev)
         if(IERC20(Cybs).balanceOf(address(this))>=1000000000000000000)
         IERC20(Cybs).transfer(operator,1000000000000000000);
         }
    }
    
     mapping(address => bool) public CypherVaultFactory;
     address payable public CypherVault=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
     address payable public Cybs=0x05fB5AF286e6deCC51580Da738dB78900f8B54E4;
     address payable public Dev=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
  
    function balance(address token,uint256 id)external view returns(uint256){
          uint256 u=ERC1155(token).balanceOf(address(this),id);
        return u;
    }

    
    function setOwner(address payable owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(((msg.sender==CypherVault)||(CypherVaultFactory[msg.sender])),"permission required");
        CypherVaultFactory[factory]=b;
    }
    
    function ownerNFT(address owner)public view  returns( nft[] memory){
        return ownedList[owner];
    }
    
}
 
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using SafeMath for uint256;
    using Address for address;
     mapping(uint256 => uint256)public totalSupply;
    
    address public Dev = 0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    address public Curator = 0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    address public Curricular = 0x3a326C47D7471B87360661Cc8Ad070AB87C87756;
    address public CypherShop = 0x7CDcFdC26ab31c678d6cE3b0aDE389D78dA59761;
    address public Tracker = 0x627f97533A3dE2dbB32217f947907d99A136269d;

    event ncx(address indexed who,address cx,uint256 id);
    buffer[]public waiting;
    mapping(uint256 => bool)public curatorClaim; 
    mapping(uint256 => bool)public artistClaim; 
    uint256 public index=0;
    
    struct buffer{
        address author;
        string name;
        string symbol;
        uint256 amount;
        string uri;
    }
    
    function mintSetPrice(uint256 id,string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
        require(msg.sender==Curator,"permission required");
        buffer memory buf= waiting[id];
        index++;
        _balances[index][CypherShop] = 95;
        _balances[index][buf.author] = 3;
        _balances[index][Curator] = 1;
        _balances[index][Dev] = 1;
        emit TransferSingle(address(this), address(this), CypherShop, index, 95);
        emit TransferSingle(address(this), address(this), buf.author, index, 3);
        emit TransferSingle(address(this), address(this), Curator, index, 1);
        emit TransferSingle(address(this), address(this), Dev, index, 1);
        _uri[index]=buf.uri;
        totalSupply[index]=100;
        tracker(Tracker).track(Dev,address(this),index);
        tracker(Tracker).track(buf.author,address(this),index);
        tracker(Tracker).track(Curator,address(this),index);
        ICypherCardShop1155(CypherShop).setPrice(payable(Curator),payable(buf.author),address(this),index);
        emit ncx(buf.author,address(this),index);
        //DirectCurricularFactory(Curricular).claim(operator);
        return true;
    }
    
    
    function mintNow(string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
         require(msg.sender==Curator,"permission required");
        index++;
        _balances[index][CypherShop] = 98;
        _balances[index][Curator] = 1;
        _balances[index][Dev] = 1;
        emit TransferSingle(address(this), address(this), CypherShop, index, 98);
        emit TransferSingle(address(this), address(this), Curator, index, 1);
        emit TransferSingle(address(this), address(this), Dev, index, 1);
        _uri[index]=uri;
        totalSupply[index]=100;
        tracker(Tracker).track(Dev,address(this),index);
        tracker(Tracker).track(CypherShop,address(this),index);
        emit ncx(Curator,address(this),index);
        //DirectCurricularFactory(Curricular).claim(operator);
        return true;
    }
    
    function submitCard(string memory name,string memory symbol,uint256 amount,string memory uri)public returns(bool){
        waiting.push(buffer(msg.sender,name,symbol,amount,uri));
        return true;
    }
    
  
    
    
    function setCurator(address curator) public {
        require(msg.sender==Curator,"permission required");
        Curator=curator;
    }
    
    function setCurricular(address contr) public {
        require(msg.sender==Dev,"permission required");
        Curricular=contr;
    }
    
    function setCypherShop(address contr) public {
        require(msg.sender==Dev,"permission required");
        CypherShop=contr;
    }
    
    function setTracker(address contr) public {
        require(msg.sender==Dev,"permission required");
        Tracker=contr;
    }
    

    // Mapping from token ID to account balances
    mapping (uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    

    // Used as the URI for all token types by relying on ID substition, e.g. https://token-cdn-domain/{id}.json
    string private collection_uri;
    mapping (uint256 => string) private _uri;

    /*
     *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
     *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
     *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
     *
     *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
     *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
     */
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;

    /*
     *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
     */
    bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;

    /**
     * @dev See {_setURI}.
     */
    constructor (string memory uri) public {
        _setURI(uri);

        // register the supported interfaces to conform to ERC1155 via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155);

        // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substituion mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256 id) external view override returns (string memory) {
        return _uri[id];
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    )
        public
        view
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
            batchBalances[i] = _balances[ids[i]][accounts[i]];
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(_msgSender() != operator, "ERC1155: setting approval status for self");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    )
        public
        virtual
        override
    {
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        address operator = _msgSender();

 

        _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
        _balances[id][to] = _balances[id][to].add(amount);

        emit TransferSingle(operator, from, to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        public
        virtual
        override
    {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );

        address operator = _msgSender();



        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            _balances[id][from] = _balances[id][from].sub(
                amount,
                "ERC1155: insufficient balance for transfer"
            );
            _balances[id][to] = _balances[id][to].add(amount);
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }

    function _setURI(string memory newuri) internal virtual {
        _uri[0] = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
        require(account != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();

  

        _balances[id][account] = _balances[id][account].add(amount);
        emit TransferSingle(operator, address(0), account, id, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
    }

   

    /**
     * @dev Destroys `amount` tokens of token type `id` from `account`
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens of token type `id`.
     */
    function _burn(address account, uint256 id, uint256 amount) internal virtual {
        require(account != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();


        _balances[id][account] = _balances[id][account].sub(
            amount,
            "ERC1155: burn amount exceeds balance"
        );

        emit TransferSingle(operator, account, address(0), id, amount);
    }



    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */


    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    )
        private
    {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver(to).onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        private
    {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
                if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}



contract ICypherCardShop1155{
    address payable public CypherVault=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    address public Tracker=0x3E5592bFB8ce2210e344b7177C01547bcB76c614;
    mapping(address =>  mapping(uint256 => uint256))public prices;
    mapping(address => mapping(uint256 => address payable))public creators;
    mapping(address => mapping(uint256 => address payable))public curators;
    //event scx(address cx);
    uint256 public shopType=2;
    uint256 public startprice=10000000000000000;
        
    function buy(address token,uint256 id,uint256 amount)public payable returns(bool){
        prices[token][id]+=amount*100000000000000;
        require(msg.value>=prices[token][id]*amount,"more honey!");
        uint256 t=msg.value/3;
        CypherVault.transfer(t);
        curators[token][id].transfer(t);
        creators[token][id].transfer(msg.value-(t*2));
        //require(IERC20(token).transfer(msg.sender, 1000000000000000000*amount),"wtf?");
        ERC1155(token).safeTransferFrom(address(this),msg.sender,id,amount,"");
        tracker(Tracker).track(msg.sender,token,id);
        //emit scx(token,id);
        return true;
    }
    
    function setPrice(address payable curator,address payable author,address vault,uint256 id) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[vault][id]=startprice;
        curators[vault][id]=curator;
        creators[vault][id]=author;
    }
    
    function setStartPrice(uint256 price) external{
       require(msg.sender==CypherVault,"permission required");
       startprice=price;
    }
    
    function balance(address token,uint256 id)external view returns(uint256){
          uint256 u=ERC1155(token).balanceOf(address(this),id);
        return u;
    }

    

    mapping(address => bool) public CypherVaultFactory;
    
    function setOwner(address payable owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setTracker(address addr)payable public {
        require(msg.sender==CypherVault,"permission required");
        Tracker=addr;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory[factory]=b;
    }
    

}

interface IERC20 {
  
    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

}
