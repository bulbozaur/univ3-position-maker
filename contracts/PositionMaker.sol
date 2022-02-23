// SPDX-License-Identifier: MIT
pragma solidity =0.8.12;
import './interfaces/INonfungiblePositionManager.sol';
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PositionMaker {
    using SafeERC20 for IERC20;

    INonfungiblePositionManager public constant positionManager = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    IERC20 public constant wsteth = IERC20(0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0);
    IERC20 public constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    uint256 public position; 

    constructor() {

    }

    function createPosition(uint256 amount0, uint256 amount1) public{

        wsteth.safeApprove(address(positionManager), amount0);
        weth.safeApprove(address(positionManager), amount1);
        INonfungiblePositionManager.MintParams({
            token0: address(wsteth),
            token1: address(weth),
            fee: 500,
            tickLower: 500,
            tickUpper: 700,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        });
        (position, , , ) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
            token0: address(wsteth),
            token1: address(weth),
            fee: 500,
            tickLower: 500,
            tickUpper: 700,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp + 10
        }));
        wsteth.safeApprove(address(positionManager), 0);
        weth.safeApprove(address(positionManager), 0);
    }
}