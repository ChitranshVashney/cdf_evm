// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GaussianCDFContract} from "../src/GaussianCDF.sol";

contract GaussianCDFTest is Test {
    GaussianCDFContract public gaussian;

    function setUp() public {
        gaussian = new GaussianCDFContract();
    }

    function testCdfZero() public {
        int256 result = gaussian.cdf(0, 0, 1e18);
        int256 expected = 5e17; // CDF(0) of standard normal is 0.5
        // console.log(result);
        assertApproxEqAbs(result, expected, 1e8, "CDF(0, 0, 1) should be 0.5");
    }

    function testCdfNonStandard() public {
        int256 result = gaussian.cdf(1e18, 1e18, 2e18);
        int256 expected = 5e17; // CDF(1, 1, 2) should be 0.5
        assertApproxEqAbs(result, expected, 1e8, "CDF(1, 1, 2) should be 0.5");
    }
}
