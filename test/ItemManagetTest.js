
const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("... should let you create new Items", async () => {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 400;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
        console.log(itemManagerInstance);

        assert.equal(result.logs[0].args.index, 0, "The should be one item index in there");
        const item = await itemManagerInstance.items(0);
        assert.equal(item.identifier, itemName, "The item has different identifier");
    })
})