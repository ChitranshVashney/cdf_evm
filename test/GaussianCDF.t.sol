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

    function testCdfPositive() public {
        int256 mu = 0 * 1e18; // Mean
        int256 sigma = 1 * 1e18; // Standard deviation
        int256 x = 1 * 1e18; // Value for which CDF is to be computed
        int256 expectedCdfValue = 0.8413447460685429 * 1e18; // Expected CDF value for x=1, mu=0, sigma=1
        assertApproxEqAbs(
            gaussian.cdf(x, mu, sigma),
            expectedCdfValue,
            1e18,
            "CDF calculation for positive x failed"
        );
    }

    function testCdfNegative() public {
        int256 mu = 0 * 1e18; // Mean
        int256 sigma = 1 * 1e18; // Standard deviation
        int256 x = -1 * 1e18; // Value for which CDF is to be computed
        int256 expectedCdfValue = 0.1586552539314571 * 1e18; // Expected CDF value for x=-1, mu=0, sigma=1
        assertApproxEqAbs(
            gaussian.cdf(x, mu, sigma),
            expectedCdfValue,
            1e18,
            "CDF calculation for negative x failed"
        );
    }

    function testCdfExtremes() public {
        int256 mu = 0 * 1e18;
        int256 sigma = 1 * 1e18;

        // Extremely low z
        int256 xLow = -100 * 1e18; // Very low value
        assertEq(
            gaussian.cdf(xLow, mu, sigma),
            0,
            "CDF should be 0 for very low x"
        );

        // Extremely high z
        int256 xHigh = 100 * 1e18; // Very high value
        assertEq(
            gaussian.cdf(xHigh, mu, sigma),
            1e18,
            "CDF should be 1 for very high x"
        );
    }

    function testCdfWithNonPositiveSigma() public {
        int256 mu = 0 * 1e18;
        int256 nonPositiveSigma = 0 * 1e18; // Zero or negative sigma

        // This should revert
        vm.expectRevert("sigma must be positive");
        gaussian.cdf(1 * 1e18, mu, nonPositiveSigma);
    }

    function testCdfWithLargeInputs() public {
        int256 mu = 0 * 1e18;
        int256 sigma = 1 * 1e18;

        // Large negative value
        int256 largeNegative = -40 * 1e18;
        assertEq(
            gaussian.cdf(largeNegative, mu, sigma),
            0,
            "CDF should be 0 for very large negative value"
        );

        // Large positive value
        int256 largePositive = 40 * 1e18;
        assertEq(
            gaussian.cdf(largePositive, mu, sigma),
            1e18,
            "CDF should be 1 for very large positive value"
        );
    }
}
