
contract Meta {

    mapping(address => string)public meta;

    function setMeta(address _contract,string memory val)public returns(bool){
        meta[_contract]=val;
        return true;
    }
    
}
