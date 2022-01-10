//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFTsurance is ERC1155 {
    struct Insurance {
        IERC721 nft;
        uint256 payout;
        IERC20 payoutToken;
        uint256 expiry;
        address insurer;
    }

    mapping(uint256 => Insurance) public insurances;

    constructor(string memory baseURI)  ERC1155(baseURI) {}

    function createInsurance(IERC721 nft, uint256 payout, IERC20 payoutToken,uint256 expiry, uint256 amount) external {
        require(expiry > block.timestamp, "Insurance must expire in the future");
        uint256 id = uint256(keccak256(abi.encodePacked(nft, payout, payoutToken, expiry, amount)));
        insurances[id] = Insurance(nft, payout, payoutToken, expiry, msg.sender);
        payoutToken.transferFrom(msg.sender, address(this), payout*amount);
        _mint(msg.sender, id, amount, "0x");
    }

    function useInsurance(uint256 id, uint256[] memory nftIds) external {
        Insurance memory insurance = insurances[id];
        require(insurance.expiry < block.timestamp, "Insurance has expired");
        for (uint256 j = 0; j < nftIds.length; j++) {
            insurance.nft.safeTransferFrom(msg.sender, insurance.insurer, nftIds[j]);
        }
        insurance.payoutToken.transfer(msg.sender, nftIds.length*insurance.payout);
        _burn(msg.sender, id, nftIds.length);
    }

    function useInsurance(uint256[] memory ids, uint256[][] memory nftIds) external {
        for (uint256 i = 0; i < ids.length; i++) {
            Insurance memory insurance = insurances[ids[i]];
            require(insurance.expiry < block.timestamp, "Insurance has expired");
            for (uint256 j = 0; j < nftIds[i].length; j++) {
                insurance.nft.safeTransferFrom(msg.sender, insurance.insurer, nftIds[i][j]);
            }
            insurance.payoutToken.transfer(msg.sender, nftIds[i].length*insurance.payout);
            _burn(msg.sender, ids[i], nftIds[i].length);
        }
    }
}
