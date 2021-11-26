module.exports = {
  networks: {
    development: {
      host: "0.0.0.0",
      port: 8546,
      network_id: "*", // Match any network id
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
