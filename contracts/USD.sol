//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./SupplyManager.sol";

/*
    *This is an algorithmic stable coin
    *Minteable and burnable
    *Using access control to set roles:
        *1.Owner => does some basic functions such as 
        deploying the contract and seting up the contract
        *2.SupplyManager => Can pause the contract if there
        are issues with the parity
        [SEE SupplyManager contract]


*/


contract StableCoin is 
ERC20 , 
Ownable,
Pausable{

    modifier onlySupplyManager(){
        require(_msgSender()==_supplyManager);
        _;
    }

    modifier onlyOwnerOrAdmin(){
        require(_msgSender()==owner() ||_msgSender()==_supplyManager);
        _;
    }

    address private _supplyManager; //supply manager address
    uint256 public fees; // the fees for using the stablecoin

    constructor(
        string memory name,
        string memory symbol
    )
    ERC20(name , symbol) Ownable(){}

    /**
     */
    function pause()  public onlyOwnerOrAdmin{
        _pause();
    }

    function unpause() public  onlyOwner{
        _unpause();
    }


    function setSupplyManger(address newSupplyManager) public  onlyOwner{
        _supplyManager = newSupplyManager;
    }
    function mint(uint256 amount ) public whenNotPaused  onlySupplyManager returns(bool){
        _mint(_supplyManager , amount*(100-fees)/100);
        return true;
    }

    function burn(uint256 amount) public whenNotPaused  onlySupplyManager returns(bool){
        _burn(_supplyManager , amount);
        return true;
    }
    function supplyManager() public view returns(address){
        return _supplyManager;
    }

}