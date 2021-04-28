// SPDX-License-Identifier: MIT

pragma  experimental ABIEncoderV2;


import "./IERC1155.sol";
import "./IERC1155MetadataURI.sol";
import "./IERC1155Receiver.sol";
import "../../GSN/Context.sol";
import "../../introspection/ERC165.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";



contract Collections{
    
        address[] public collections;
        mapping(address => bool) public CypherVaultFactory;
        address payable public CypherVault=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
        mapping(address => address) public owners;
        mapping(address => address[]) public ownerOf;
        

    
    function addCollection(address creator,address collection)public{
            require(CypherVaultFactory[msg.sender],"permission required");
            collections.push(collection);
            owners[collection]=creator;
            ownerOf[creator].push(collection);
    }
    
   
   
    

    function setCypherVaultFactory(address factory,bool b)payable public {
        require(((msg.sender==CypherVault)||(CypherVaultFactory[msg.sender])),"permission required");
        CypherVaultFactory[factory]=b;
    }
    
}
    


 contract CollectionsFactoryMatic {
     

    address public CypherCardShop=0x7CF3947a530Ab8375Bc3e52aa35999E2366436Fa;
    address public Tracker=0x4e923a2901C6366648179dacEDc5F0711dE9AEce;
    address public Collection=0x8D3D6D6eBe136278995ea0ba7B76402C7B2a6F86;
    address public CypherVault=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    
    function createCollection(string memory uri) public returns(bool) {
        ERC1155 collection=new ERC1155(msg.sender,uri);
        Collections(Collection).addCollection(msg.sender,address(collection));
        ICypherCardShop1155(CypherCardShop).setCypherVaultFactory(address(collection),true);
        tracker(Tracker).setCypherVaultFactory(address(collection),true);
        return true;
        
    }
    
    function setOwner(address owner) public {
        require(msg.sender==CypherVault,"permission required");
        CypherVault=owner;
    }
    
    function setCollection(address collection) public {
        require(msg.sender==CypherVault,"permission required");
        Collection=collection;
    }


}
 
 contract ICurricularFactory {
  
    function claim(address account) public returns(bool) { return true;}


}
 
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
     address payable public Cybs=0x1EcB0D257c3D8b5Ab52880b359558E363971848d;
     address payable public Dev=0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
  

   
    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(((msg.sender==CypherVault)||(CypherVaultFactory[msg.sender])),"permission required");
        CypherVaultFactory[factory]=b;
    }

    
}
 
contract ERC1155 is Context, ERC165,  IERC1155, IERC1155MetadataURI  {
    using SafeMath for uint256;
    using Address for address;
     mapping(uint256 => uint256)public totalSupply;
    
    address public Dev = 0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    address public Curator = 0x00936EFE90dEdaB2a6a623BF90Bee10AD6910a8b;
    address public Curricular = 0x5b541C1f4E8497630D127B71c21DE385EE6DC2CD;
    address public CypherShop = 0x7CF3947a530Ab8375Bc3e52aa35999E2366436Fa;
    address public Tracker = 0x4e923a2901C6366648179dacEDc5F0711dE9AEce;
    mapping(address => bool)public permissioned;
    mapping(uint256 => address) public creator;
    address[] public curators;
    event ncx(address indexed who,address cx,uint256 id);
    buffer[]public waiting;
    uint256 public index=0;
    
    struct buffer{
        address author;
        string name;
        string symbol;
        uint256 amount;
        string uri;
    }
    
     /// @dev This event MUST be emitted by `onRoyaltiesReceived()`.
    event RoyaltiesReceived(
        address indexed _royaltyRecipient,
        address indexed _buyer,
        uint256 indexed _tokenId,
        address _tokenPaid,
        uint256 _amount,
        bytes32 _metadata
    );
    
    function mintSetPrice(uint256 id,string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
        require(permissioned[msg.sender],"permission required");
        buffer memory buf= waiting[id];
        index++;
        _balances[index][CypherShop] += 95;
        _balances[index][buf.author] += 3;
        _balances[index][Curator] += 1;
        _balances[index][Dev] += 1;
        emit TransferSingle(address(this), address(this), CypherShop, index, 95);
        emit TransferSingle(address(this), address(this), buf.author, index, 3);
        emit TransferSingle(address(this), address(this), Curator, index, 1);
        emit TransferSingle(address(this), address(this), Dev, index, 1);
        _uri[index]=buf.uri;
        totalSupply[index]=100;
        creator[index]=buf.author;
        tracker(Tracker).track(Dev,address(this),index);
        tracker(Tracker).track(buf.author,address(this),index);
        tracker(Tracker).track(Curator,address(this),index);
        ICypherCardShop1155(CypherShop).setPrice(payable(Curator),payable(buf.author),address(this),index);
        emit ncx(buf.author,address(this),index);
        ICurricularFactory(Curricular).claim(buf.author);
        return true;
    }
    
    
    function mintNow(string memory name,string memory symbol,uint256 amount,string memory uri) public returns(bool){
         require(permissioned[msg.sender],"permission required");
        index++;
        _balances[index][CypherShop] += 95;
        _balances[index][msg.sender] += 3;
        _balances[index][Curator] += 1;
        _balances[index][Dev] += 1;
        emit TransferSingle(address(this), address(this), CypherShop, index, 95);
        emit TransferSingle(address(this), address(this), msg.sender, index, 3);
        emit TransferSingle(address(this), address(this), Curator, index, 1);
        emit TransferSingle(address(this), address(this), Dev, index, 1);
        _uri[index]=uri;
        totalSupply[index]=100;
        creator[index]=msg.sender;
        tracker(Tracker).track(Dev,address(this),index);
        tracker(Tracker).track(msg.sender,address(this),index);
        tracker(Tracker).track(Curator,address(this),index);
        emit ncx(Curator,address(this),index);
        ICurricularFactory(Curricular).claim(Curator);
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
    
    function addCurator(address curator,bool b) public {
        require(msg.sender==Curator,"permission required");
        permissioned[curator]=b;
        curators.push(curator); 
    }
    
    function curatorsList() external view returns(address[] memory) {
        return curators;
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
    
    function onRoyaltiesReceived(address _royaltyRecipient, address _buyer, uint256 _tokenId, address _tokenPaid, uint256 _amount, bytes32 _metadata) external returns (bytes4){
        emit RoyaltiesReceived(
         _royaltyRecipient,
         _buyer,
        _tokenId,
        _tokenPaid,
        _amount,
        _metadata
    );
    return bytes4(keccak256("onRoyaltiesReceived(address,address,uint256,address,uint256,bytes32)"));
    }
    
    function royaltyInfo(uint256 _tokenId) external returns (address,uint24){
        return (creator[_tokenId],1000000);
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

    bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
    
    bytes4 private constant _INTERFACE_ID_ERC721ROYALTIES = 0x263d4ef1;

 
    constructor (address operator,string memory uri) public {
        _setURI(uri);
        permissioned[Curator]=true;
        creator[0]=operator;
        // register the supported interfaces to conform to ERC1155 via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155);

        // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
       
     _registerInterface(_INTERFACE_ID_ERC721ROYALTIES);
    }

    function uri(uint256 id) external view override returns (string memory) {
        return _uri[id];
    }


    function balanceOf(address account, uint256 id) public view override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }

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

 
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(_msgSender() != operator, "ERC1155: setting approval status for self");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }


    function isApprovedForAll(address account, address operator) public view override returns (bool) {
        return _operatorApprovals[account][operator];
    }

  
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
        
        tracker(Tracker).track(to,address(this),id);
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
            tracker(Tracker).track(to,address(this),id);
            _balances[id][from] = _balances[id][from].sub(
                amount,
                "ERC1155: insufficient balance for transfer"
            );
            _balances[id][to] = _balances[id][to].add(amount);
        }

        
        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }
    
    function setBasicURI(string memory newuri) public virtual {
         require(permissioned[msg.sender],"permission required");
        _uri[0] = newuri;
    }

    function _setURI(string memory newuri) internal virtual {
        _uri[0] = newuri;
    }


    function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
        require(account != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();

  

        _balances[id][account] = _balances[id][account].add(amount);
        emit TransferSingle(operator, address(0), account, id, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
    }

   function burn(uint256 id, uint256 amount) public returns(bool){
        require(_burn(msg.sender,id,amount),"problems burning");
        return true;
   }

    function _burn(address account, uint256 id, uint256 amount) internal virtual returns(bool){
        require(account != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();


        _balances[id][account] = _balances[id][account].sub(
            amount,
            "ERC1155: burn amount exceeds balance"
        );

        emit TransferSingle(operator, account, address(0), id, amount);
        return true;
    }

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
    address public Tracker=0x4e923a2901C6366648179dacEDc5F0711dE9AEce;
    mapping(address => bool) public CypherVaultFactory;
    mapping(address =>  mapping(uint256 => uint256))public prices;
    mapping(address => mapping(uint256 => address payable))public creators;
    mapping(address => mapping(uint256 => address payable))public curators;
    //event scx(address cx);
    uint256 public shopType=2;
    uint256 public startprice=10000000000000000000;
    uint256 public increment=500000000000000000;
        
    function buy(address token,uint256 id,uint256 amount)public payable returns(bool){
        prices[token][id]+=amount*increment;
        require(msg.value>=prices[token][id]*amount,"more honey!");
        uint256 t=msg.value/3;
        CypherVault.transfer(t);
        curators[token][id].transfer(t);
        creators[token][id].transfer(msg.value-(t*2));
        ERC1155(token).safeTransferFrom(address(this),msg.sender,id,amount,"");
        tracker(Tracker).track(msg.sender,token,id);
        return true;
    }
    
    function setPrice(address payable curator,address payable author,address vault,uint256 id) external{
        require(CypherVaultFactory[msg.sender],"permission required");
        prices[vault][id]=startprice;
        curators[vault][id]=curator;
        creators[vault][id]=author;
    }
   

    
    function setCypherVaultFactory(address factory,bool b)payable public {
        require(((msg.sender==CypherVault)||(CypherVaultFactory[msg.sender])),"permission required");
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



