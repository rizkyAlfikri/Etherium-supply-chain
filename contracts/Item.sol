// SPDX-License-Identifier: RIZ

pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item {
    uint256 public priceInWei;
    uint256 public paidWei;
    uint256 public index;

    ItemManager parentContract;

    constructor(
        ItemManager _itemManager,
        uint256 _priceInWei,
        uint256 _index
    ) {
        parentContract = _itemManager;
        priceInWei = _priceInWei;
        index = _index;
    }

    receive() external payable {
        require(priceInWei == msg.value, "We don't support partial payment");
        require(paidWei == 0, "Item has already paid");

        paidWei += msg.value;
        (bool isSuccess, ) = address(parentContract).call{value: msg.value}(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );

        require(isSuccess, "Payment not success");
    }

    fallback() external payable {}
}
