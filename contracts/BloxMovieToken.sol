import "./ERC20StandardToken.sol";
import "./SafeMath.sol";

contract BloxMovieToken is ERC20StandardToken {
    using SafeMath for uint256;

    address public owner;
    address public movieOwner;
    string public name;
    uint256 public minBudget;
    uint256 public maxBudget;
    string public symbol;
    uint8 public decimal;


    //public constants
    uint256 public MAX_SUPPLY = 10000;
    uint256 public BASE_RATE;
    uint256 public currentSupply;
    bool public tokenSaleClosed;

    function BloxMovieToken(
      address _movieOwner,
      string _name,
      uint256 _minBudget,
      uint256 _maxBudget,
      string _symbol,
      uint8 _decimal
    ) {
      owner = msg.sender;
      movieOwner = _movieOwner;
      name =  _name;
      minBudget = _minBudget;
      maxBudget = _maxBudget;
      symbol = _symbol;
      decimal = _decimal;
      BASE_RATE = maxBudget.div(MAX_SUPPLY);
    }

 // start Token sale
 function startSale () public {
   tokenSaleClosed = false;
 }

 //stop Token sale
 function stopSale () public  {
   tokenSaleClosed = true;
 }

 /// @dev This default function allows token to be purchased by directly
 /// sending ether to this smart contract.
 function () public payable {
     purchaseTokens(msg.sender);
 }

 /// @dev Issue token based on Ether received.
 /// @param _beneficiary Address that newly issued token will be sent to.
 function purchaseTokens(address _beneficiary) internal  {

     uint256 tokens = computeTokenAmount(msg.value);

     balances[_beneficiary] = balances[_beneficiary].add(tokens);

     /// forward the raised funds to the fund address
     owner.transfer(msg.value);
 }


 /// @dev Compute the amount of ING token that can be purchased.
 /// @param ethAmount Amount of Ether to purchase ING.
 /// @return Amount of CHERToken token to purchase
 function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
     /// the percentage value (0-100) of the discount for each tier
     //uint64 discountPercentage = currentTierDiscountPercentage();

     uint256 tokenBase = ethAmount.mul(BASE_RATE);
     //uint256 tokenBonus = tokenBase.mul(discountPercentage).div(100);

     tokens = tokenBase;
 }

 //Default discount 10%
 function currentTierDiscountPercentage() internal view returns (uint64) {
   return 10;
 }


 function doIssueTokens(address _beneficiary, uint256 _tokensAmount) public {
     require(_beneficiary != address(0));

     // compute without actually increasing it
     uint256 increasedTotalSupply = currentSupply.add(_tokensAmount);
     // roll back if hard cap reached
     require(increasedTotalSupply <= MAX_SUPPLY);

     // increase token total supply
       currentSupply = increasedTotalSupply;
     // update the buyer's balance to number of tokens sent
     balances[_beneficiary] = balances[_beneficiary].add(_tokensAmount);
 }

}
