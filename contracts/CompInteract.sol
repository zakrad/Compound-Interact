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
        address underlyingaddress = cToken.underlying();
        
    }
}