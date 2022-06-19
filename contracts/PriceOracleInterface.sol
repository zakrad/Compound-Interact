pragma solidity ^0.8.8;

interface PriceOracleInterface {
  function getUnderlyingPrice(address asset) external view returns(uint);
}