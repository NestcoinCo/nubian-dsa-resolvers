pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface IPancakeswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface TokenInterface {
    function allowance(address, address) external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function approve(address, uint256) external;

    function transfer(address, uint256) external returns (bool);

    function decimals() external view returns (uint256);

    function totalSupply() external view returns (uint256);
}

interface IPancakeswapPair {
    function balanceOf(address owner) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);
}

interface IPancakeswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Babylonian {
    // credit for this implementation goes to
    // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
        // however that code costs significantly more gas
        uint256 xx = x;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) {
            xx >>= 128;
            r <<= 64;
        }
        if (xx >= 0x10000000000000000) {
            xx >>= 64;
            r <<= 32;
        }
        if (xx >= 0x100000000) {
            xx >>= 32;
            r <<= 16;
        }
        if (xx >= 0x10000) {
            xx >>= 16;
            r <<= 8;
        }
        if (xx >= 0x100) {
            xx >>= 8;
            r <<= 4;
        }
        if (xx >= 0x10) {
            xx >>= 4;
            r <<= 2;
        }
        if (xx >= 0x8) {
            r <<= 1;
        }
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x / r;
        return (r < r1 ? r : r1);
    }
}

contract DSMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "sub-overflow");
    }

    uint256 constant WAD = 10**18;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
}

contract Helpers is DSMath {
    /**
     * @dev get Bnb address
     */
    function getEthAddr() public pure returns (address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
}

contract PancakeswapHelpers is Helpers {
    using SafeMath for uint256;

    /**
     * @dev Return WETH address
     */
    function getAddressWETH() internal pure returns (address) {
        return 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // bsc testnet
    }

    /**
     * @dev Return uniswap v2 router02 Address
     */
    function getPancakeAddr() internal pure returns (address) {
        return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    }

    function convert18ToDec(uint256 _dec, uint256 _amt)
        internal
        pure
        returns (uint256 amt)
    {
        amt = (_amt / 10**(18 - _dec));
    }

    function convertTo18(uint256 _dec, uint256 _amt)
        internal
        pure
        returns (uint256 amt)
    {
        amt = mul(_amt, 10**(18 - _dec));
    }

    function changeEthAddress(address buy, address sell)
        internal
        pure
        returns (TokenInterface _buy, TokenInterface _sell)
    {
        _buy = buy == getEthAddr()
            ? TokenInterface(getAddressWETH())
            : TokenInterface(buy);
        _sell = sell == getEthAddr()
            ? TokenInterface(getAddressWETH())
            : TokenInterface(sell);
    }

    function getExpectedBuyAmt(
        address buyAddr,
        address sellAddr,
        uint256 sellAmt
    ) internal view returns (uint256 buyAmt) {
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        address[] memory paths = new address[](2);
        paths[0] = address(sellAddr);
        paths[1] = address(buyAddr);
        uint256[] memory amts = router.getAmountsOut(sellAmt, paths);
        buyAmt = amts[1];
    }

    function getExpectedSellAmt(
        address buyAddr,
        address sellAddr,
        uint256 buyAmt
    ) internal view returns (uint256 sellAmt) {
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        address[] memory paths = new address[](2);
        paths[0] = address(sellAddr);
        paths[1] = address(buyAddr);
        uint256[] memory amts = router.getAmountsIn(buyAmt, paths);
        sellAmt = amts[0];
    }

    function getBuyUnitAmt(
        TokenInterface buyAddr,
        uint256 expectedAmt,
        TokenInterface sellAddr,
        uint256 sellAmt,
        uint256 slippage
    ) internal view returns (uint256 unitAmt) {
        uint256 _sellAmt = convertTo18((sellAddr).decimals(), sellAmt);
        uint256 _buyAmt = convertTo18(buyAddr.decimals(), expectedAmt);
        unitAmt = wdiv(_buyAmt, _sellAmt);
        unitAmt = wmul(unitAmt, sub(WAD, slippage));
    }

    function getSellUnitAmt(
        TokenInterface sellAddr,
        uint256 expectedAmt,
        TokenInterface buyAddr,
        uint256 buyAmt,
        uint256 slippage
    ) internal view returns (uint256 unitAmt) {
        uint256 _buyAmt = convertTo18(buyAddr.decimals(), buyAmt);
        uint256 _sellAmt = convertTo18(sellAddr.decimals(), expectedAmt);
        unitAmt = wdiv(_sellAmt, _buyAmt);
        unitAmt = wmul(unitAmt, add(WAD, slippage));
    }

    function _getWithdrawUnitAmts(
        TokenInterface tokenA,
        TokenInterface tokenB,
        uint256 amtA,
        uint256 amtB,
        uint256 uniAmt,
        uint256 slippage
    ) internal view returns (uint256 unitAmtA, uint256 unitAmtB) {
        uint256 _amtA = convertTo18(tokenA.decimals(), amtA);
        uint256 _amtB = convertTo18(tokenB.decimals(), amtB);
        unitAmtA = wdiv(_amtA, uniAmt);
        unitAmtA = wmul(unitAmtA, sub(WAD, slippage));
        unitAmtB = wdiv(_amtB, uniAmt);
        unitAmtB = wmul(unitAmtB, sub(WAD, slippage));
    }

    function _getWithdrawAmts(
        TokenInterface _tokenA,
        TokenInterface _tokenB,
        uint256 uniAmt
    ) internal view returns (uint256 amtA, uint256 amtB) {
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        address exchangeAddr =
            IPancakeswapV2Factory(router.factory()).getPair(
                address(_tokenA),
                address(_tokenB)
            );
        require(exchangeAddr != address(0), "pair-not-found.");
        TokenInterface uniToken = TokenInterface(exchangeAddr);
        uint256 share = wdiv(uniAmt, uniToken.totalSupply());
        amtA = wmul(_tokenA.balanceOf(exchangeAddr), share);
        amtB = wmul(_tokenB.balanceOf(exchangeAddr), share);
    }

    function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
        internal
        pure
        returns (uint256)
    {
        return
            Babylonian
                .sqrt(
                reserveIn.mul(userIn.mul(3988000).add(reserveIn.mul(3988009)))
            )
                .sub(reserveIn.mul(1997)) / 1994;
    }
}

contract Resolver is PancakeswapHelpers {
    function getBuyAmount(
        address buyAddr,
        address sellAddr,
        uint256 sellAmt,
        uint256 slippage
    ) public view returns (uint256 buyAmt, uint256 unitAmt) {
        (TokenInterface _buyAddr, TokenInterface _sellAddr) =
            changeEthAddress(buyAddr, sellAddr);
        buyAmt = getExpectedBuyAmt(
            address(_buyAddr),
            address(_sellAddr),
            sellAmt
        );
        unitAmt = getBuyUnitAmt(_buyAddr, buyAmt, _sellAddr, sellAmt, slippage);
    }

    function getSellAmount(
        address buyAddr,
        address sellAddr,
        uint256 buyAmt,
        uint256 slippage
    ) public view returns (uint256 sellAmt, uint256 unitAmt) {
        (TokenInterface _buyAddr, TokenInterface _sellAddr) =
            changeEthAddress(buyAddr, sellAddr);
        sellAmt = getExpectedSellAmt(
            address(_buyAddr),
            address(_sellAddr),
            buyAmt
        );
        unitAmt = getSellUnitAmt(
            _sellAddr,
            sellAmt,
            _buyAddr,
            buyAmt,
            slippage
        );
    }

    function getDepositAmount(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 slippageA,
        uint256 slippageB
    )
        public
        view
        returns (
            uint256 amountB,
            uint256 uniAmount,
            uint256 amountAMin,
            uint256 amountBMin
        )
    {
        (TokenInterface _tokenA, TokenInterface _tokenB) =
            changeEthAddress(tokenA, tokenB);
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        IPancakeswapV2Factory factory = IPancakeswapV2Factory(router.factory());
        IPancakeswapPair lpToken =
            IPancakeswapPair(
                factory.getPair(address(_tokenA), address(_tokenB))
            );
        require(address(lpToken) != address(0), "No-exchange-address");

        (uint256 reserveA, uint256 reserveB, ) = lpToken.getReserves();
        (reserveA, reserveB) = lpToken.token0() == address(_tokenA)
            ? (reserveA, reserveB)
            : (reserveB, reserveA);

        amountB = router.quote(amountA, reserveA, reserveB);

        uniAmount = mul(amountA, lpToken.totalSupply());
        uniAmount = uniAmount / reserveA;

        amountAMin = wmul(sub(WAD, slippageA), amountA);
        amountBMin = wmul(sub(WAD, slippageB), amountB);
    }

    function getSingleDepositAmount(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 slippage
    )
        public
        view
        returns (
            uint256 amtA,
            uint256 amtB,
            uint256 uniAmt,
            uint256 minUniAmt
        )
    {
        (TokenInterface _tokenA, TokenInterface _tokenB) =
            changeEthAddress(tokenA, tokenB);
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        IPancakeswapV2Factory factory = IPancakeswapV2Factory(router.factory());
        IPancakeswapPair lpToken =
            IPancakeswapPair(
                factory.getPair(address(_tokenA), address(_tokenB))
            );
        require(address(lpToken) != address(0), "No-exchange-address");

        (uint256 reserveA, uint256 reserveB, ) = lpToken.getReserves();
        (reserveA, reserveB) = lpToken.token0() == address(_tokenA)
            ? (reserveA, reserveB)
            : (reserveB, reserveA);

        uint256 swapAmtA = calculateSwapInAmount(reserveA, amountA);

        amtB = getExpectedBuyAmt(address(_tokenB), address(_tokenA), swapAmtA);
        amtA = sub(amountA, swapAmtA);

        uniAmt = mul(amtA, lpToken.totalSupply());
        uniAmt = uniAmt / add(reserveA, swapAmtA);

        minUniAmt = wmul(sub(WAD, slippage), uniAmt);
    }

    function getDepositAmountNewPool(
        address tokenA,
        address tokenB,
        uint256 amtA,
        uint256 amtB
    ) public view returns (uint256 unitAmt) {
        (TokenInterface _tokenA, TokenInterface _tokenB) =
            changeEthAddress(tokenA, tokenB);
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());
        address exchangeAddr =
            IPancakeswapV2Factory(router.factory()).getPair(
                address(_tokenA),
                address(_tokenB)
            );
        require(exchangeAddr == address(0), "pair-found.");
        uint256 _amtA18 = convertTo18(_tokenA.decimals(), amtA);
        uint256 _amtB18 = convertTo18(_tokenB.decimals(), amtB);
        unitAmt = wdiv(_amtB18, _amtA18);
    }

    function getWithdrawAmounts(
        address tokenA,
        address tokenB,
        uint256 uniAmt,
        uint256 slippage
    )
        public
        view
        returns (
            uint256 amtA,
            uint256 amtB,
            uint256 unitAmtA,
            uint256 unitAmtB
        )
    {
        (TokenInterface _tokenA, TokenInterface _tokenB) =
            changeEthAddress(tokenA, tokenB);
        (amtA, amtB) = _getWithdrawAmts(_tokenA, _tokenB, uniAmt);
        (unitAmtA, unitAmtB) = _getWithdrawUnitAmts(
            _tokenA,
            _tokenB,
            amtA,
            amtB,
            uniAmt,
            slippage
        );
    }
}

contract PancakeswapPositionGetter is PancakeswapHelpers {
    struct TokenPair {
        address tokenA;
        address tokenB;
    }

    struct PoolData {
        address tokenA;
        address tokenB;
        address lpAddress;
        uint256 reserveA;
        uint256 reserveB;
        uint256 tokenAShareAmt;
        uint256 tokenBShareAmt;
        uint256 tokenABalance;
        uint256 tokenBBalance;
        uint256 lpAmount;
        uint256 totalSupply;
    }

    function getPositionByPair(address owner, TokenPair[] memory tokenPairs)
        public
        view
        returns (PoolData[] memory)
    {
        IPancakeswapV2Router02 router =
            IPancakeswapV2Router02(getPancakeAddr());

        PoolData[] memory poolData = new PoolData[](tokenPairs.length);
        for (uint256 i = 0; i < tokenPairs.length; i++) {
            (TokenInterface tokenA, TokenInterface tokenB) =
                changeEthAddress(tokenPairs[i].tokenA, tokenPairs[i].tokenB);
            address exchangeAddr =
                IPancakeswapV2Factory(router.factory()).getPair(
                    address(tokenA),
                    address(tokenB)
                );
            if (exchangeAddr != address(0)) {
                IPancakeswapPair lpToken = IPancakeswapPair(exchangeAddr);
                (uint256 reserveA, uint256 reserveB, ) = lpToken.getReserves();
                (reserveA, reserveB) = lpToken.token0() == address(tokenA)
                    ? (reserveA, reserveB)
                    : (reserveB, reserveA);

                uint256 lpAmount = lpToken.balanceOf(owner);
                uint256 totalSupply = lpToken.totalSupply();
                uint256 share = wdiv(lpAmount, totalSupply);
                uint256 amtA = wmul(reserveA, share);
                uint256 amtB = wmul(reserveB, share);
                poolData[i] = PoolData(
                    address(0),
                    address(0),
                    address(lpToken),
                    reserveA,
                    reserveB,
                    amtA,
                    amtB,
                    0,
                    0,
                    lpAmount,
                    totalSupply
                );
            }
            poolData[i].tokenA = tokenPairs[i].tokenA;
            poolData[i].tokenB = tokenPairs[i].tokenB;
            poolData[i].tokenABalance = tokenPairs[i].tokenA == getEthAddr()
                ? owner.balance
                : tokenA.balanceOf(owner);
            poolData[i].tokenBBalance = tokenPairs[i].tokenB == getEthAddr()
                ? owner.balance
                : tokenB.balanceOf(owner);
        }
        return poolData;
    }

    function getPosition(address owner, address[] memory lpTokens)
        public
        view
        returns (PoolData[] memory)
    {
        PoolData[] memory poolData = new PoolData[](lpTokens.length);

        // for (uint256 i = 0; i < lpTokens.length; i++) {
        //     IPancakeswapPair lpToken = IPancakeswapPair(lpTokens[i]);
        //     (uint256 reserveA, uint256 reserveB, ) = lpToken.getReserves();
        //     (address tokenA, address tokenB) = (lpToken.token0(), lpToken.token1());

        //     uint256 share = wdiv(lpToken.balanceOf(owner), lpToken.totalSupply());
        //     uint256 amtA = wmul(reserveA, share);
        //     uint256 amtB = wmul(reserveB, share);

        //     uint256 balA = TokenInterface(tokenA).balanceOf(owner);
        //     uint256 balB = TokenInterface(tokenB).balanceOf(owner);

        //     poolData[i] = PoolData(
        //         tokenA == getAddressWETH() ? getEthAddr() : tokenA,
        //         tokenB == getAddressWETH() ? getEthAddr() : tokenB,
        //         address(lpToken),
        //         reserveA,
        //         reserveB,
        //         amtA,
        //         amtB,
        //         tokenA == getAddressWETH()
        //             ? owner.balance
        //             : balA,
        //         tokenB == getAddressWETH()
        //             ? owner.balance
        //             : balB,
        //         lpToken.balanceOf(owner),
        //         lpToken.totalSupply()
        //     );
        // }
        return poolData;
    }
}

contract BxdPancakeswapResolver is Resolver {
    string public constant name = "Pancakeswap-Resolver-v1.1";
}
