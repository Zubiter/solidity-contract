// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "./ZubiterClonableERC721.sol";

contract Zubiter is Ownable, Pausable {
    event CreateToken(address indexed owner, address token);
    event ChangeFee(uint256 fee);

    address private _clonableERC721;
    uint256 public _fee = 0;
    bool private _frozen;

    constructor () {
        Ownable.initialize();
    }

    function createToken(string memory name, string memory symbol) external whenNotPaused payable {
        require(msg.value >= _fee);
        payable(owner()).transfer(msg.value);

        bytes20 targetBytes = bytes20(_clonableERC721);
        ZubiterClonableERC721 token;
        assembly {
        let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            token := create(0, clone, 0x37)
        }

        token.initialize(name, symbol, _msgSender());
        emit CreateToken(_msgSender(), address(token));
    }

    function setFee(uint256 fee) external onlyOwner {
        _fee = fee;
    }

    function setTemplate(address template) external onlyOwner {
        _clonableERC721 = template;
    }

    function getTokenTemplate() public view returns(address clonableERC721) {
        clonableERC721 = _clonableERC721;
    }
}