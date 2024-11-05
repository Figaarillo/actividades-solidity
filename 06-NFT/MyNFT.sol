// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    constructor() ERC721("MyNFT", "MNT") {
        _safeMint(msg.sender, 1); // Mintea el NFT con tokenId 1 al creador del contrato
    }

    function transferNFT(address from, address to, uint256 tokenId) external {
        // Comprobamos si el llamador es el propietario o tiene aprobación
        require(
            msg.sender == ownerOf(tokenId) || getApproved(tokenId) == msg.sender,
            "No autorizado para transferir"
        );
        safeTransferFrom(from, to, tokenId);
    }
}
