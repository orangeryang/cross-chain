const ethers = require("ethers");
const fs = require("fs");

const url = "https://rpc.mevblocker.io";
// const url = "https://eth.merkle.io";
const provider = new ethers.JsonRpcProvider(url);

const contract = new ethers.Contract("0x86f7692569914b5060ef39aab99e62ec96a6ed45", ["function seeds(uint256) public view returns (uint256)",], provider);

const main = async () => {

    console.log("start");

    const block = await provider.getBlockNumber();
    console.log("block:" + block);

    let array = [];
    for (let i = 1; i <= 9000; i++) {

        console.log("id: " + i);
        const seed = await contract.seeds(i);
        // console.log("seed: " + seed);
        const hex = ethers.toBeHex(seed);
        console.log("hex: " + hex);
        array.push("self.seeds.write(" + i + "," + hex + ");");

    }
    console.log(array);

    const arrayString = JSON.stringify(array);

    const filePath = "path/seeds.json";
    const content = arrayString;

    fs.writeFile(filePath, content, (err) => {
        if (err) {
            console.error("Error writing file:", err);
        } else {
            console.log("File written successfully.");
        }
    });

}

main();