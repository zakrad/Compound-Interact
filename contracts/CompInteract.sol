pragma solidity 0.8.8;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './CTokenInterface';
import './ComptrollerInterface';
import './PriceOracleInterface';

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
        cTokenInterface cToken = CTokenInterface(cTokenAddress);
        uint result = cToken.redeem(cTokenAmount);
        require(
            result == 0,
            'cToken#redeem() failed see more detail in ErrorReporter.sol of Compound'
        );
    }
}