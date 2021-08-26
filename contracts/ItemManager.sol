// SPDX-License-Identifier: RIZ

pragma solidity ^0.8.0;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable {
    enum ItemManagerState {
        Created,
        Paid,
        Delivered
    }

    struct ItemModel {
        Item item;
        string identifier;
        ItemManager.ItemManagerState state;
    }

    modifier checkArgument(string memory _identidier, uint256 _price) {
        require(bytes(_identidier).length > 0, "Argument must not be empty");
        require(_price > 0, "Price must not be zero");
        _;
    }

    modifier checkIsItemExist(uint256 _index) {
        require(
            bytes(items[_index].identifier).length > 0,
            "The item selected is not exist"
        );
        _;
    }

    mapping(uint256 => ItemModel) public items;
    uint256 index;

    event SupplyChainEventStep(uint256 index, uint256 step, address _address);

    function createItem(string memory _identifier, uint256 _price)
        public
        checkArgument(_identifier, _price)
        onlyOwner
    {
        Item item = new Item(this, _price, index);
        items[index].item = item;
        items[index].state = ItemManagerState.Created;
        items[index].identifier = _identifier;

        emit SupplyChainEventStep(
            index,
            uint256(items[index].state),
            address(item)
        );
        index++;
    }

    function triggerPayment(uint256 _index)
        public
        payable
        checkIsItemExist(_index)
    {
        require(
            items[_index].state == ItemManagerState.Created,
            "Item is further in the supply chain"
        );

        items[_index].state = ItemManagerState.Paid;
        emit SupplyChainEventStep(
            _index,
            uint256(items[_index].state),
            address(items[_index].item)
        );
    }

    function triggerDelivery(uint256 _index)
        public
        checkIsItemExist(_index)
        onlyOwner
    {
        require(
            items[_index].state == ItemManagerState.Paid,
            "Item is further in the supply chain"
        );

        items[_index].state = ItemManagerState.Delivered;
        emit SupplyChainEventStep(
            _index,
            uint256(items[_index].state),
            address(items[_index].item)
        );
    }
}
