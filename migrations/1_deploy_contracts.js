const HealthCare = artifacts.require("HealthCare");

const TO_LAB_ADMIN_ADDRESS = "0xe3Bc617552B440B1380a09c45C0FAf2bA214205C"; // hard coded address from Ganache

module.exports = function (deployer) {
  deployer.deploy(HealthCare, TO_LAB_ADMIN_ADDRESS);
};