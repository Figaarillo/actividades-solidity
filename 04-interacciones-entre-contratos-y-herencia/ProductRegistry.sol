// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ProductRegistry {
    struct Product {
        string name;
        uint price;
        uint stock;
    }

    mapping(uint => Product) public products;
    address public owner;

    event ProductRegistered(uint indexed productId, string name, uint price, uint stock);
    event ProductUpdated(uint indexed productId, uint price, uint stock);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerProduct(uint _id, string memory _name, uint _price, uint _stock) public onlyOwner {
        products[_id] = Product(_name, _price, _stock);
        emit ProductRegistered(_id, _name, _price, _stock);
    }

    function updateProduct(uint _id, uint _price, uint _stock) public onlyOwner {
        require(bytes(products[_id].name).length != 0, "Product does not exist.");
        products[_id].price = _price;
        products[_id].stock = _stock;
        emit ProductUpdated(_id, _price, _stock);
    }

    function getProduct(uint _id) public view returns (string memory, uint, uint) {
        Product memory product = products[_id];
        return (product.name, product.price, product.stock);
    }
}
