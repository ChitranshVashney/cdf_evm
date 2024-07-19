# GaussianCDFContract

## Overview

The `GaussianCDFContract` is a Solidity smart contract designed to compute the Cumulative Distribution Function (CDF) of a Gaussian (normal) distribution. The CDF is crucial in statistics, providing the probability that a random variable drawn from a Gaussian distribution is less than or equal to a specified value.

By utilizing fixed-point arithmetic, this contract ensures precision in calculations, which is especially important in financial and statistical applications.

## Key Concepts

- **CDF (Cumulative Distribution Function)**: A function that describes the probability that a random variable takes on a value less than or equal to `x`.
- **Gaussian Distribution**: A continuous probability distribution defined by its mean (μ) and standard deviation (σ).
- **Fixed-Point Arithmetic**: A method of representing real numbers that allows for precise calculations without floating-point errors.

## Contract Functions

The contract implements several internal and public functions:

- **`errorFunc`**

  ```js
  function errorFunc(int256 x) internal pure returns (int256)
  ```

- **`errorFunc`**

  ```js
  function cdf(int256 x, int256 mu, int256 sigma) public pure returns (int256)
  ```
