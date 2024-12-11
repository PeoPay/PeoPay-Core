// These tests verify the functionality of the Conversion contract, which allows users
// to request PEO-to-mobile money conversions and the authorized backend service to confirm them.
//
// Key scenarios tested:
// - Requesting a conversion with zero amount (should revert)
// - Requesting a conversion without token approval (should revert)
// - Emitting the ConversionRequested event on valid requests
// - Confirming the conversion by an unauthorized address (should revert)
// - Allowing the backend service (authorized) to confirm conversion successfully

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Conversion", function () {
  let PeoCoin, Conversion, peoCoin, conversion;
  let owner, user, backendService;

  beforeEach(async () => {
    // Get three different signers: owner, user, and backendService
    [owner, user, backendService] = await ethers.getSigners();

    // Deploy a fresh instance of PeoCoin before each test
    PeoCoin = await ethers.getContractFactory("PeoCoin");
    peoCoin = await PeoCoin.deploy();
    await peoCoin.waitForDeployment();

    // Deploy the Conversion contract, passing in PeoCoin address and backendService address
    Conversion = await ethers.getContractFactory("Conversion");
    conversion = await Conversion.deploy(await peoCoin.getAddress(), await backendService.getAddress());
    await conversion.waitForDeployment();

    // Transfer some PEO tokens from the owner (initial holder) to the user for testing conversions
    await peoCoin.transfer(await user.getAddress(), ethers.parseUnits("1000", 18));
  });

  it("Should revert if user tries to request conversion with zero amount", async function () {
    // Trying to request a conversion of 0 tokens should fail, as it makes no sense
    // and is explicitly prevented by the contract.
    await expect(
      conversion.connect(user).requestConversion(0, "123456789", "KES")
    ).to.be.revertedWith("Amount must be greater than zero");
  });

  it("Should revert if user tries to request conversion without approval", async function () {
    // Without approving the Conversion contract to spend the user's tokens,
    // the transferFrom in requestConversion will fail, causing a revert.
    await expect(
      conversion.connect(user).requestConversion(ethers.parseUnits("100", 18), "123456789", "KES")
    ).to.be.revertedWithCustomError(peoCoin, "ERC20InsufficientAllowance");
  });

  it("Should emit event on valid conversion request", async function () {
    // User must first approve the Conversion contract to spend their tokens.
    await peoCoin.connect(user).approve(await conversion.getAddress(), ethers.parseUnits("100", 18));

    // After approval, a valid request should succeed and emit the "ConversionRequested" event.
    await expect(
      conversion.connect(user).requestConversion(ethers.parseUnits("100", 18), "123456789", "KES")
    ).to.emit(conversion, "ConversionRequested");
  });

  it("Should revert if unauthorized address tries to confirm conversion", async function () {
    // Approve tokens and request a conversion successfully.
    await peoCoin.connect(user).approve(await conversion.getAddress(), ethers.parseUnits("100", 18));
    await conversion.connect(user).requestConversion(ethers.parseUnits("100", 18), "123456789", "KES");

    // Now try to confirm conversion from a non-backendService address (user in this case).
    // This should revert since only backendService can confirm.
    await expect(
      conversion.connect(user).confirmConversion(await user.getAddress(), ethers.parseUnits("100", 18), "123456789")
    ).to.be.revertedWith("Unauthorized caller");
  });

  it("Should allow the backendService to confirm conversion", async function () {
    // The backendService is authorized to confirm the conversion.
    // First, user must request a conversion.
    await peoCoin.connect(user).approve(await conversion.getAddress(), ethers.parseUnits("200", 18));
    await conversion.connect(user).requestConversion(ethers.parseUnits("200", 18), "987654321", "KES");

    // backendService confirms conversion successfully, emitting the "ConversionConfirmed" event.
    await expect(
      conversion.connect(backendService).confirmConversion(await user.getAddress(), ethers.parseUnits("200", 18), "987654321")
    ).to.emit(conversion, "ConversionConfirmed");
  });
});
