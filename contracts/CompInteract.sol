pragma solidity 0.8.8;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './CTokenInterface.sol';
import './ComptrollerInterface.sol';
import './PriceOracleInterface.sol';

contract CompInteract {
    ComptrollerInterface public comptroller;
    PriceOracleInterface public priceOracle;

    constructor (address _comptroller, address _priceOracle) {
        comptroller = ComptrollerInterface(_comptroller);
        priceOracle = PriceOracleInterface(_priceOracle);
    }

    function supply(address cTokenAddress, uint underlyingAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint result = cToken.mint(underlyingAmount);
        require(
            result == 0,
            'cToken#mint() failed see more detail in ErrorReporter.sol of Compound'
        );
    }

    function redeem(address cTokenAddress, uint cTokenAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        uint result = cToken.redeem(cTokenAmount);
        require(
            result == 0,
            'cToken#redeem() failed see more detail in ErrorReporter.sol of Compound'
        );
    }

    function enterMarket(address cTokenAddress) external {
        address[] memory markets = new address[](1);
        markets[0] = cTokenAddress;
        uint[] memory results = comptroller.enterMarkets(markets);
        require(
            results[0] == 0,
            'comptroller#enterMarket() failed. see more detail in ErrorReporter.sol of Compound'
        );
    }

    function borrow(address cTokenAddress, uint borrowAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        uint result = cToken.borrow(borrowAmount);
        require(
            result == 0,
            'cToken#borrow() failed. see more detail in ErrorReporter.sol of Compound'
        );
    }

    function repayBorrow(address cTokenAddress, uint underlyingAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint result = cToken.repayBorrow(underlyingAmount);
        require(
            result == 0,
            'cToken#repayBorrow() failed. see more detail in ErrorReporter.sol of Compound'
        );
    }

    function getmaxBorrow(address cTokenAddress) external view returns(uint){
        (uint result, uint liquidity, uint shortfall) = comptroller
        .getAccountLiquidity(address(this));
        require(
            result == 0,
            'comptroller#getAccountLiquidity() failed. see more detail in ErrorReporter.sol of Compound'
        );
        require(shortfall == 0, 'account underwater');
        require(liquidity > 0, 'account does not have collateral');
        uint udnerlyingPrice = priceOracle.getUnderlyingPrice(cTokenAddress);
        return liquidity / udnerlyingPrice;

    }
}