// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using SafeMath for uint256;
    using Address for address;
        mapping(uint256 => uint256)public totalSupply;
        address public CypherVault = 0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
        address public Curricular = 0x5e767a6C282f26DE3133D5C4B7305ea2d5cB5A1B;
        address public CypherShop1155 = 0xa3eBfAAe3Dd81A79F592c601618F55B46d4502e0;
        event ncx(address indexed who,address cx,uint256 id);
    // Mapping from token ID to account balances
    mapping (uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping (address => mapping(address => bool)) private _operatorApprovals;

    
    mapping (uint256 => string) private _uri;
    uint256 public index;
     
    function setCurricular(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        Curricular=contr;
    }
    
    function setCypherShop(address contr)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherShop1155=contr;
    }
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
    constructor () public {

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
    function uri(uint256 urii) external view override returns (string memory) {
        return _uri[urii];
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

        _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

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

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

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

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substituion mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
 

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
     
     mapping(string  => address)public owners;
     mapping(string  => mapping(uint256  => mapping(uint256  => mapping(uint256  => bool))))public minted;
     mapping(address => uint256)public credit;
     mapping(string => address)public parent;
     mapping(string => string)public names;
     mapping(string => uint256)public prices;
     uint256 public x;
     uint256 public y;
     uint256 public z;
     
     function buy(string parent,string memory x,string memory  y,string memory  z,string memory name) payable public returns(bool){
         string s=parent+a+b+c;
         require(msg.value>=prices[parent],"more honey");
         require(owners[parent]!=address(0),"buy upper level");
         require(owners[s]==address(0),"taken");
         credit[owners[parent]]=credit[parent].add(1000000000000000000);
         _balances[s][msg.sender] = _balances[s][msg.sender].add(1000000000000000000);
         minted[parent][x][y][z];
         owners[s]=msg.sender;
         parent[s]=owners[parent];
         prices[parent]++;
         return true;
     }
     
     function scan(string memory parent)public view returns(string){
         string memory s="";
         for(uint256 i=0;i<x;i++){
          for(uint256 j=0;j<y;j++){
           for(uint256 k=0;k<z;k++){
             s=s+minted[parent][i][j][k];
         }  
         }   
         }
         return s;
     }
     
     function name(string parent,uint256 x,uint256 y,uint256 z) public returns(bool){
         string s=parent+a+b+c;
         require(owners[parent]!=address(0),"buy upper level");
         require(owners[s]==address(0),"taken");
         owners[parent].transfer(msg.value);
         credit[owners[parent]]=credit[parent].add(1000000000000000000);
         _balances[s][msg.sender] = _balances[s][msg.sender].add(1000000000000000000);
         minted[parent][x][y][z];
         owners[s]=msg.sender;
         parent[s]=owners[parent];
         return true;
     }
     
     function withdraw(string memory plot)public{
         msg.sender.transfer(credit[msg.sender]);
     }
     
     
     function owner(string memory parent)public view returns(address){
         string memory s=parent+a+b+c;
         return owners[s];
     }
     
    function mintSetPrice(address operator,string memory name,string memory symbol,uint256 amount,string memory uri,uint256 price) public returns(bool){
        index++;
        ICypherShop1155(CypherShop1155).setPrice(payable(operator),address(this),index,price);
        _balances[index][CypherShop1155] = _balances[index][CypherShop1155].add(1000000000000000000*amount);
        totalSupply[index]=amount;
        _uri[index]=uri;
         emit ncx(operator,address(this),index);
        ICurricular(Curricular).claim(operator);
        return true;
    }
    
    function mintSend(address operator,string memory name,string memory symbol,uint256 amount,string memory uri,address to) public returns(bool){
        index++;
        _balances[index][operator] = _balances[index][operator].add(1000000000000000000*amount);
        totalSupply[index]=amount;
        _uri[index]=uri;
        emit TransferSingle(operator, address(0), operator, index, amount);
        emit ncx(operator,address(this),index);
        ICurricular(Curricular).claim(operator);
        return true;
    }
     
    function _mint(address account, uint256 id, uint256 amount, string memory uri,bytes memory data)internal virtual{
        require(account != address(0), "ERC1155: mint to the zero address");
        
        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
         index++;
        _balances[index][account] = _balances[index][account].add(amount);
        
        _uri[index]=uri;
        emit TransferSingle(operator, address(0), account, index, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), account, index, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
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

        _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");

        _balances[id][account] = _balances[id][account].sub(
            amount,
            "ERC1155: burn amount exceeds balance"
        );

        emit TransferSingle(operator, account, address(0), id, amount);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
        require(account != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");

        for (uint i = 0; i < ids.length; i++) {
            _balances[ids[i]][account] = _balances[ids[i]][account].sub(
                amounts[i],
                "ERC1155: burn amount exceeds balance"
            );
        }

        emit TransferBatch(operator, account, address(0), ids, amounts);
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
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal virtual
    { }

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


contract ICypherShop1155{
    mapping(address => mapping(uint256 => uint256))public prices;
    mapping(address => mapping(uint256 => address payable))public creators;
    event scx(address cx);
        
    function buy(address token,uint256 id)public payable returns(bool){
        require(msg.value>=prices[token][id],"more honey!");
        creators[token][id].transfer(msg.value);
        ERC1155(token).safeTransferFrom(address(this), msg.sender,id,msg.value/prices[token][id]*1000000000000000000,"0x");
        emit scx(token);
        return true;
    }
    
    function setPrice(address payable author,address t,uint256 id,uint256 p) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[t][id]=p;
        creators[t][id]=author;
    }
    
    function changePrice(address t,uint256 id,uint256 p) external{
        require(msg.sender==creators[t][id],"permission required");
        prices[t][id]=p;
    }
    
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    mapping(address => bool) public CypherVaultFactory;
    
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory[factory]=b;
    }
    

}

interface IEthItem {
    function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
    function transfer(address recipient, uint256 amount) external returns (bool);
}


contract ICurricular {
    function claim(address to)public {}
}


contract Emitter {
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    mapping(address => bool) public CypherVaultFactory;
    event ncx(address indexed who,address cx,uint256 id);
    
    //for erc1155
    function emit1155(address from,uint256 id)public {
        require(CypherVaultFactory[msg.sender],"permission required");
        emit ncx(from,msg.sender,id);
    }
    
    
    //for items
    function emitItem(address from,address token)public {
        require(CypherVaultFactory[msg.sender],"permission required");
        emit ncx(from,token,0);
    }
    
     function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVaultFactory[factory]=b;
    }
}

contract equityDistributor {
    address public equities=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
    address public CypherVault=0xdA1Ec8F2Fb47e905079663bCEA69f1a2B010f2D3;
      
      function setEquities(address contr)public{
        require(msg.sender==CypherVault,"permission required");
        equities=contr;
    }
    
        
    function setOwner(address owner)payable public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    
    function mintSetPrice(address vault,string memory name,string memory symbol,uint256 amount,string memory uri,uint256 price) public {
        require(ERC1155(vault).mintSetPrice(msg.sender,name,symbol,amount,uri,price),"something wrong");
        IEthItem(equities).transfer(msg.sender, 1000000000000000000);
    }
    
}


