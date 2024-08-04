pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract WTFApe is ERC721{

    uint public MAX_APES = 10000; // 总量

    function _baseURI() internal pure override returns(string memory){
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    constructor(uint256 _amount) ERC721("WTF", "WTF") {
        
    }

    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out of range");
        _mint(to, tokenId);
    }

}