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
