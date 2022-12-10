const HealthCare = artifacts.require("HealthCare");
const TO_LAB_ADMIN_ADDRESS = "0x8BEA8a08802e3dD501aFc605E4c5E2aA279EbD1f"; // hard coded address from Ganache

module.exports = function (deployer) {
  deployer.deploy(HealthCare, TO_LAB_ADMIN_ADDRESS);
};