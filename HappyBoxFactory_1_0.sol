contract Happybox_1_0_Factory{
    
        uint public code=1;
        
        function install()public returns(bool){
            HappyBox hb=new HappyBox();
            require(hb.set(msg.sender,false,2));
            require(Ownership(0x1660D644C164C779F41cE27110DdD55336800ED6).setOwner(msg.sender,address(hb)));
            return true;
        }
        
}
