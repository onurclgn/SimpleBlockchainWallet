// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract Allowance is Ownable{
    event AllowanceUpdated(address indexed _forWho, address indexed _forWhom,uint _oldAmount, uint _newAmount);

    mapping (address => uint) public allowances; // Contract holds allowances.
    uint allowedMoneyTotal; 
    function isOwner() public view returns(bool){
        return msg.sender==owner();
    }

    // Contract will permission only if he/she is owner or he/she has allowance that amount.
    modifier ownerOrAllowed(uint _amount){
        require(isOwner() || allowances[msg.sender]>= _amount,"You are not allowed that much of money");
        _;
    }

    function reduceAllowance (address _who, uint _amount) internal {
        emit AllowanceUpdated(_who,msg.sender,allowances[_who],(allowances[_who]-_amount));
            allowances[_who]-=_amount;
    }

    // Owner can give allowance to employees. 
    function giveAllowance (address _to,uint _amount) public onlyOwner{
            require(address(this).balance>=(allowedMoneyTotal+_amount),"There is no enough money in this contract");
            emit AllowanceUpdated(_to,msg.sender,allowances[_to],(allowances[_to]+_amount));
            allowances[_to]+=_amount;
            allowedMoneyTotal+=_amount;
    }


}