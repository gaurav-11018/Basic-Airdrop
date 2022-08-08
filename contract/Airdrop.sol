// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Airdrop {
    struct airdrop {
        address nft;
        uint16 id;
    }
    uint256 public nextAirdrop;
    address public admin;
    mapping(uint => airdrop) public airdrops;
    mapping(address => bool) public recipients;

    constructor() {
        admin = msg.sender;
    }

    function addAirdrops(airdrop[] memory _airdrops, uint256 nextAirdropId)
        external
    {
        require(msg.sender == admin, "only admin");
        uint256 _nextAirdropId = nextAirdropId;
        for (uint i = 0; i < _airdrops.length; i++) {
            airdrops[_nextAirdropId] = _airdrops[i];
            IERC721(_airdrops[i].nft).transferFrom(
                msg.sender,
                address(this),
                _airdrops[i].id
            );
            _nextAirdropId++;
        }
    }

    function addRecipients(address[] memory _recipients) external {
        require(msg.sender == admin, "only admin");
        for (uint i = 0; i < _recipients.length; i++) {
            recipients[_recipients[i]] = true;
        }
    }

    function removeRecipients(address[] memory _recipients) external {
        require(msg.sender == admin, "only admin");
        for (uint i = 0; i < _recipients.length; i++) {
            recipients[_recipients[i]] = true;
        }
    }

    function claim() external {
        require(recipients[msg.sender] == true, "Sry not registered!1");
        recipients[msg.sender] = false;
        airdrop storage s_airdrop = airdrops[nextAirdrop];
        IERC721(s_airdrop.nft).transferFrom(
            address(this),
            msg.sender,
            s_airdrop.id
        );
        nextAirdrop++;
    }
}
