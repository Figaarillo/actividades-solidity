// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMarketplace is ERC721URIStorage {
    uint256 public tokenCounter; // Contador de NFTs
    IERC20 public paymentToken; // Token ERC-20 para pagos

    struct Listing {
        address seller;
        uint256 price; // Precio en token ERC-20
        uint256 tokenId;
        bool isERC20; // Indicador de si se aceptará ERC-20
    }

    mapping(uint256 => Listing) public listings; // Mapeo de NFT a su listado

    constructor(address tokenAddress) ERC721("MyNFT", "MNT") {
        paymentToken = IERC20(tokenAddress); // Dirección del token ERC-20
        tokenCounter = 0; // Inicializar el contador de tokens
    }

    // Función para mintear un nuevo NFT
    function mintNFT(string memory tokenURI) public returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId); // Mintear el NFT
        _setTokenURI(newTokenId, tokenURI); // Establecer URI del NFT
        tokenCounter++; // Incrementar el contador
        return newTokenId;
    }

    // Función para listar un NFT para venta
    function listNFT(uint256 tokenId, uint256 price, bool acceptERC20) public {
        require(ownerOf(tokenId) == msg.sender, "Not the NFT owner");
        require(isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");
        listings[tokenId] = Listing(msg.sender, price, tokenId, acceptERC20);
    }

    // Función para comprar un NFT usando Ether
    function buyNFTWithEther(uint256 tokenId) public payable {
        Listing storage listing = listings[tokenId];
        require(listing.isERC20 == false, "This NFT can only be bought with ERC-20");
        require(msg.value >= listing.price, "Insufficient Ether sent");
        payable(listing.seller).transfer(msg.value); // Transferir Ether al vendedor
        _transfer(listing.seller, msg.sender, tokenId); // Transferir NFT
        delete listings[tokenId]; // Eliminar la lista
    }

    // Función para comprar un NFT usando token ERC-20
    function buyNFTWithERC20(uint256 tokenId) public {
        Listing storage listing = listings[tokenId];
        require(listing.isERC20 == true, "This NFT can only be bought with Ether");
        require(paymentToken.transferFrom(msg.sender, listing.seller, listing.price), "Payment failed");
        _transfer(listing.seller, msg.sender, tokenId); // Transferir NFT
        delete listings[tokenId]; // Eliminar la lista
    }
}
