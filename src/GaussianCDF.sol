// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract GaussianCDFContract {
    // Constants for fixed-point arithmetic
    int256 constant SQRT2 = 1414213562373095048; // sqrt(2) * 1e18 for scaling

    // Internal function to compute the error function (errorFunc) approximation
    function errorFunc(int256 x) internal pure returns (int256) {
        // Absolute value of x
        int256 z = abs(x);
        // erf approximation (Abramowitz and Stegun)
        // Compute t = 1 / (1 + p * |x|)
        int256 t = 1e18 /
            (1e18 + (z * 31830988618379067) / (100000000000000000));

        // Compute the result of the polynomial approximation
        int256 result = 1e18 -
            t * // coefficient of errorFunc approximation
            exp(
                (-z * z) /
                    1e18 + // exponent for the exp term
                    (-352513787021902989 + // coefficients for polynomial
                        t *
                        (302985994769246233 +
                            t *
                            (-127986537271042856 +
                                t *
                                (14997160103219171 +
                                    t *
                                    (-780461776943986 +
                                        t *
                                        (14819511112937)))))) /
                    1e18
            );

        // Return result based on the sign of x
        return x >= 0 ? result : -result;
    }

    // Internal function to compute the exponential of x using series expansion
    function exp(int256 x) internal pure returns (int256) {
        // Initialize sum with the first term (1)
        int256 sum = 1e18;
        // Initialize term for the series expansion
        int256 term = 1e18;

        // Compute the series expansion up to 20 terms
        for (uint256 i = 1; i < 20; i++) {
            // Calculate the next term: (term * x) / i
            term = (term * x) / (int256(i) * 1e18);
            // Add term to the sum
            sum += term;
        }

        // Return the computed exponential value
        return sum;
    }

    // Internal function to return the absolute value of x
    function abs(int256 x) internal pure returns (int256) {
        return x >= 0 ? x : -x;
    }

    // Public function to compute the Cumulative Distribution Function (CDF) of a Gaussian distribution
    function cdf(
        int256 x, // Value for which CDF is to be computed
        int256 mu, // Mean of the Gaussian distribution
        int256 sigma // Standard deviation of the Gaussian distribution
    ) public pure returns (int256) {
        // Ensure sigma is positive
        require(sigma > 0, "sigma must be positive");

        // Standardize the value x to get z
        int256 z = ((x - mu) * 1e18) / sigma;

        // Handle extreme values of z to avoid overflow in errorFunc computation
        if (z < -40 * 1e18) return 0; // CDF for very low z is approximately 0
        if (z > 40 * 1e18) return 1e18; // CDF for very high z is approximately 1

        // Compute z / sqrt(2) for the errorFunc function
        int256 zDivSqrt2 = (z * 1e18) / SQRT2;

        // Compute the CDF using the errorFunc function
        return (1e18 + errorFunc(zDivSqrt2)) / 2; // Return the CDF value
    }
}
