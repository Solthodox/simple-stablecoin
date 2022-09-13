// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConsumerV3.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";


interface IStableCoin is IERC20{
    function mint(uint256 amount) external returns(bool);
    function burn(uint256 amount) external returns(bool);
    function pause() external;
    function unpause() external;
}

/**
    *Contract made to manage the stablecoin's supply with special permissions
    *Mantains parity thanks to Chainlink data feeds
 */
   
contract SupplyManager is PriceConsumerV3 , ReentrancyGuard , Context{

    event alertThresholdHit(uint256 timestamp);
    event emergencyThresholdHit(uint256 timestamp);
    IStableCoin _token;
    uint256  public alertThreshold;
    uint256  public emergencyThreshold;
    
    
    constructor(address tokenAddress , uint256 alertThreshold , uint256 emergenyThreshold ){
        _token = IStableCoin(tokenAddress);
        alertThreshold = alertThreshold;
        emergencyThreshold = emergencyThreshold;

    }

    /**
        *Function to deposit ETH and get some coins
        *Gets the latest ETH price => getLatestPrice()
        *Calculates the amount of tokens to give back
        *Should give 1 token per $ of value of the ETHs deposited
        *Mints the needed amount directly from the stablecoin contract
        *Checks if the parity hits any security thresholds and alerts 
        abut it.

    */

    function swapETH() public payable{
        int256 currentPrice = getLatestPrice();
        uint256 tokenAmount = msg.value * uint256(currentPrice) /(10**8);
        require(_token.transfer(_msgSender() , tokenAmount));
        require(_token.mint(tokenAmount));
        _updateUsdRatio(currentPrice);

    }
    /**
        *The reverse functionality (deposit tokens and get ETH back)
    
    */

    function swapCoin(uint256 amount) public nonReentrant{
        require(_token.transferFrom(_msgSender(), address(this), amount));
        int256 currentPrice = getLatestPrice();
        require(_token.burn(amount));
        uint256 ethAmount = amount  * (10**8) / uint256(currentPrice);
        (bool success , ) = _msgSender().call{ value : ethAmount}('');
        require(success );
        _updateUsdRatio(currentPrice);
       
    }
    //the stablecoin's supply
    function totalSupply() public view returns(uint256){
        return _token.totalSupply();
    }
    //assets backing the supply(ETH)
    function totalAssets() public view returns(uint256){
        return address(this).balance;
    }
    /**
    @notice Checks if the token has enouugh liquidity 
     */
    function _updateUsdRatio(int256 latestPrice) private{
        uint256 alertThresholdValue = totalAssets() * uint256(latestPrice) /(10**8) * alertThreshold/ 100;
        if( alertThresholdValue <= totalSupply()  ){
            emit alertThresholdHit(block.timestamp);

        }
        else if ((totalAssets() * uint256(latestPrice) /(10**8) * emergencyThreshold/ 100) <= totalSupply() ){
            _token.pause();
            emit emergencyThresholdHit(block.timestamp);
        }
    }
}