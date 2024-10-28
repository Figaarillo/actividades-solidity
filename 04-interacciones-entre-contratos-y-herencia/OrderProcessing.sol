// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ProductRegistry.sol";

contract OrderProcessing {
    ProductRegistry public registry;
    address public owner;

    struct Order {
        uint productId;
        uint quantity;
        address buyer;
        uint totalPaid;
        bool fulfilled;
    }

    Order[] public orders;
    mapping(address => uint[]) public orderHistory;

    event OrderPlaced(uint indexed orderId, uint productId, address indexed buyer, uint quantity, uint totalPaid);
    event OrderFulfilled(uint indexed orderId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized.");
        _;
    }

    constructor(address _registryAddress) {
        registry = ProductRegistry(_registryAddress);
        owner = msg.sender;
    }

    function orderProduct(uint _productId, uint _quantity) public payable {
        (, uint price, uint stock) = registry.getProduct(_productId); // Ignoramos `name`
        require(stock >= _quantity, "Insufficient stock.");
        uint totalPrice = price * _quantity;
        require(msg.value == totalPrice, "Incorrect payment.");

        // Store the order
        uint orderId = orders.length;
        orders.push(Order(_productId, _quantity, msg.sender, totalPrice, false));
        orderHistory[msg.sender].push(orderId);

        // Decrease stock in the ProductRegistry
        registry.updateProduct(_productId, price, stock - _quantity);

        emit OrderPlaced(orderId, _productId, msg.sender, _quantity, totalPrice);
    }

    function fulfillOrder(uint _orderId) public onlyOwner {
        require(_orderId < orders.length, "Order does not exist.");
        Order storage order = orders[_orderId];
        require(!order.fulfilled, "Order already fulfilled.");
        order.fulfilled = true;
        emit OrderFulfilled(_orderId);
    }

    function getOrder(uint _orderId) public view returns (uint, uint, address, uint, bool) {
        Order memory order = orders[_orderId];
        return (order.productId, order.quantity, order.buyer, order.totalPaid, order.fulfilled);
    }

    function getOrderHistory(address _buyer) public view returns (uint[] memory) {
        return orderHistory[_buyer];
    }
}
