// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MarketPlaceNFT is ERC721URIStorage, ReentrancyGuard {
    uint256 public tokenID;
    uint256 public tokenPrice = 1 ether;

    struct Auction {
        address payable seller;
        uint256 startPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        bool active;
    }

    mapping(uint256 => Auction) public auctions;

    constructor() ERC721("MarketNFT", "NFT") {}

    function mintNewToken(string memory _tokenURI) public payable returns (uint256) {
        require(msg.value >= tokenPrice, "Insufficient Ether");

        tokenID++;
        _mint(msg.sender, tokenID);
        _setTokenURI(tokenID, _tokenURI);
        
        uint256 remainder = msg.value - tokenPrice;
        if (remainder > 0) {
            payable(msg.sender).transfer(remainder); // Devolver el resto de Ether
        }

        return tokenID;
    }
    // Permite iniciar la subasta con un precio especifico
    function startAuction(uint256 _tokenId, uint256 _startPrice, uint256 _duration) external {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(!auctions[_tokenId].active, "Auction already active");

        transferFrom(msg.sender, address(this), _tokenId);

        auctions[_tokenId] = Auction({
            seller: payable(msg.sender),
            startPrice: _startPrice,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + _duration,
            active: true
        });
    }
    // Permite a los usuarios realizar pujas
    function bid(uint256 _tokenId) external payable nonReentrant {
        Auction storage auction = auctions[_tokenId];
        require(auction.active, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.value > auction.highestBid, "Bid too low");

        if (auction.highestBid != 0) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
    // Finaliza la subasta
    function endAuction(uint256 _tokenId) external nonReentrant {
        Auction storage auction = auctions[_tokenId];
        require(auction.active, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction not ended");

        auction.active = false;

        if (auction.highestBidder != address(0)) {
            _transfer(address(this), auction.highestBidder, _tokenId);
            auction.seller.transfer(auction.highestBid);
        } else {
            _transfer(address(this), auction.seller, _tokenId);
        }
    }
}
