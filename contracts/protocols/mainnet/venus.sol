pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
interface VTokenInterface {
    function exchangeRateStored() external view returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function borrowBalanceStored(address) external view returns (uint);
    function totalBorrows() external view returns (uint);
    
    function underlying() external view returns (address);
    function balanceOf(address) external view returns (uint);
    function getCash() external view returns (uint);
}
interface TokenInterface {
    function decimals() external view returns (uint);
    function balanceOf(address) external view returns (uint);
}


interface OrcaleComp {
    function getUnderlyingPrice(address) external view returns (uint);
}
interface ComptrollerLensInterface {
    function markets(address) external view returns (bool, uint, bool);
    function getAccountLiquidity(address) external view returns (uint, uint, uint);
    function claimComp(address) external;
    function compAccrued(address) external view returns (uint);
    function borrowCaps(address) external view returns (uint);
    function borrowGuardianPaused(address) external view returns (bool);
    function oracle() external view returns (address);
    function compSpeeds(address) external view returns (uint);
}

interface CompReadInterface {
    struct CompBalanceMetadataExt {
        uint balance;
        uint votes;
        address delegate;
        uint allocated;
    }

    function getCompBalanceMetadataExt(
        TokenInterface comp,
        ComptrollerLensInterface comptroller,
        address account
    ) external returns (CompBalanceMetadataExt memory);
}

contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

}

contract Helpers is DSMath {
    /**
     * @dev get Venus Comptroller
     */
    function getComptroller() public pure returns (ComptrollerLensInterface) {
        return ComptrollerLensInterface(0xfD36E2c2a6789Db23113685031d7F16329158384);
    }

    /**
     * @dev get Venus Open Feed Oracle Address
     */
    function getOracleAddress() public view returns (address) {
        return getComptroller().oracle();
    }

   

    /**
     * @dev get ETH Address
     */
    function getVETHAddress() public pure returns (address) {
        return 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
    }

    /**
     * @dev get Venus Token Address
     */
    function getVenusToken() public pure returns (TokenInterface) {
        return TokenInterface(0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63);
    }


    struct CompData {
        uint tokenPriceInEth;
        uint tokenPriceInUsd;
        uint exchangeRateStored;
        uint balanceOfUser;
        uint borrowBalanceStoredUser;
        uint totalBorrows;
        uint totalSupplied;
        uint borrowCap;
        uint supplyRatePerBlock;
        uint borrowRatePerBlock;
        uint collateralFactor;
        uint compSpeed;
        bool isComped;
        bool isBorrowPaused;
    }
}
    contract Resolver is Helpers {

    function getPriceInEth(VTokenInterface vToken) public view returns (uint priceInETH, uint priceInUSD) {
        uint decimals = getVETHAddress() == address(vToken) ? 18 : TokenInterface(vToken.underlying()).decimals();
        uint price = OrcaleComp(getOracleAddress()).getUnderlyingPrice(address(vToken));
        uint ethPrice = OrcaleComp(getOracleAddress()).getUnderlyingPrice(getVETHAddress());
        priceInUSD = price / 10 ** (18 - decimals);
        priceInETH = wdiv(priceInUSD, ethPrice);
    }

    function getCompoundData(address owner, address[] memory vAddress) public view returns (CompData[] memory) {
        CompData[] memory tokensData = new CompData[](vAddress.length);
       ComptrollerLensInterface troller = getComptroller();

        for (uint i = 0; i < vAddress.length; i++) {
            VTokenInterface vToken = VTokenInterface(vAddress[i]);
            (uint priceInETH, uint priceInUSD) = getPriceInEth(vToken);
            (,uint collateralFactor, bool isComped) = troller.markets(address(vToken));
            uint _totalBorrowed = vToken.totalBorrows();
            tokensData[i] = CompData(
                priceInETH,
                priceInUSD,
                vToken.exchangeRateStored(),
                vToken.balanceOf(owner),
                vToken.borrowBalanceStored(owner),
                _totalBorrowed,
                add(_totalBorrowed, vToken.getCash()),
                troller.borrowCaps(vAddress[i]),
                vToken.supplyRatePerBlock(),
                vToken.borrowRatePerBlock(),
                collateralFactor,
                troller.compSpeeds(vAddress[i]),
                isComped,
                troller.borrowGuardianPaused(vAddress[i])
            );
        }

        return tokensData;
    }

  

}


contract BxdVenusResolver is Resolver {
    string public constant name = "Venus-Resolver-v1.4";
}


