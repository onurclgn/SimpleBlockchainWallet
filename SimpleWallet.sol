// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./Allowance.sol";


contract WalletDeneme is Allowance {

    event SendMoney(address indexed _whoGain, uint _amount);
    event MoneyReceived(address indexed _who, uint _amount);


    // Owner can withdraw as much as he/she wants. But employees can withdraw as much as Owner's allowance.
    function withdrawMoney (uint _amount) public ownerOrAllowed(_amount) {
        address payable _to = payable (msg.sender);
        
        if(!isOwner()){
            reduceAllowance(_to,_amount); //If employee try to withdraw money, Contract will reduce his/her allowance.
        }
        emit SendMoney(msg.sender,_amount);
        _to.transfer(_amount);

    }

    // Deactive renounceOwnership function 
    function renounceOwnership() public override view onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }


    // Everyone can send money to this contract from their wallets.
    receive() external payable{
            emit MoneyReceived(msg.sender,msg.value);
    }

    // Check balance of contract.
    function getBalance()public view returns (uint) {
        return address(this).balance;

    }




}