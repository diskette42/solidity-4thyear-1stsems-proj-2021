pragma solidity ^0.8.9;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";  
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol"; 

// Assume 4000USD = 1ETH
contract newSwap is Ownable{
    
    IERC20 public token;
    
    constructor(IERC20 _token){
        token = _token;
    }

    mapping (address=>uint256) USDBalances;
    uint256 EthWallet;
    bool canMint =true;
    
    
    function SwapWithEth() public payable{
        require(remaingPoolToken()>=(msg.value)*4000,"Please swap with lower amount of ETH" );
        
        uint256 returnCoinAmt = (msg.value)*4000;
        EthWallet += msg.value;
       
        withdrawTheUSD(returnCoinAmt); // withdrawTheUSD from Token owner and Send To msg.sender
    }
    
    // Amount = wei
    function SwapWithUSD(uint256 amount) public{
        require(EthWallet >= amount/4000,"EthereumPool has no ETH");
        token.transferFrom(msg.sender,owner(),amount);
        payable(msg.sender).transfer(amount/4000);
        EthWallet -= amount/4000;
        
    }
    function ownerEthBalance() public view returns (uint256) {
      return EthWallet;
    }
    function balanceOfUSD() public view returns(uint256){
        return token.balanceOf(msg.sender);
    }
    function ownerWithdrawEth(uint256 amount)  public onlyOwner {
        require(amount <= EthWallet,"ETH Wallet doesnt have enough funds to withdraw");
        payable(owner()).transfer(amount);
        EthWallet -= amount;
    }
    function withdrawTheUSD(uint256 _amount) private{
        token.transferFrom(owner(),msg.sender,_amount);
    }
    function depositEthToPool() public onlyOwner payable{
        EthWallet+=msg.value;
    }
    // Pool = Token Owner
    function remaingPoolToken()public view returns(uint256){
        return token.balanceOf(owner());
    }
    
  
}