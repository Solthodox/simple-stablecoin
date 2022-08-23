pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
/**
    @notice Contract to contribute to the stableCoin`s liquidity by staking ETH,
    the reward is a differerent ERC20 token that can be used to 
    
 */
contract Treasury is ERC20 , ReentrancyGuard{
    // variables to calculate rewards at each time

    uint256 private s;// reward per token stored
    mapping(address => uint256) private p; //user rewards per token paid
    uint256 public totalStaked; //toal amount staked at the time
    uint256 private t; //last update time
    uint256 public constant rewardRatePerSecond = 100;
    mapping(address => uint256) private _balances;


    modifier updateReward(address account){
        s = rewardPerToken()
        t = block.timestamp;
        p[account] = earned(account);

        _;
    }

    function provideLiquidity(uint256 amount) public payable{
        require(p[msg.sender]==0,"You are aldeady staking");
        require(msg.value>=amount, "You didnt deposit the amount provided!");
        p[msg.sender]= rewardRatePerSecond  * (block.timestamp -t ) /totalStaked;
        s+=p[msg.sender];
        t = block.timestamp;
        totalStaked+=msg.value;
    }

    function claimReward() public nonReentrant{
        require(p[msg.sender]>0,"Your balance is empty");
        uint256 reward = getReward(msg.sender);
        uint256 balance = _balances[msg.sender];
        delete p[msg.sender];
        totalStaked-=balance;
        _mint(msg.sender, reward);
        payable(msg.sender).transfer(balance);


    }

    function withdraw(uint256 amount) public 

    
    
    function getReward(address account) public view returns(uint256){
        return totalStaked * (s - p[account]);
    }

   


}