// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    struct Voter {
        uint256 amount; //可以投多少票
        bool isvoted; //是否投票
        address delegator; //代理人地址
        uint256 tagretId; //投票目标ID
    }

    struct Bord {
        string name;
        uint256 totalAmount;
    }

    //主持人信息
    address public host;
    //投票人
    mapping(address => Voter) public voters;
    //看板
    Bord[] public bords;

    constructor(string[] memory names) {
        host = msg.sender;

        //给主持人一票
        voters[host].amount = 1;
        for (uint256 i = 0; i < names.length; i++) {
            Bord memory bord = Bord(names[i], 0);
            bords.push(bord);
        }
    }

    function getBordInfo() public view returns (Bord[] memory) {
        return bords;
    }

    function mandate(address[] calldata addressList) public {
        require(msg.sender == host, "only then owner has permissions.");

        for (uint256 i = 0; i < addressList.length; i++) {
            if (!voters[addressList[i]].isvoted) {
                voters[addressList[i]].amount = 1;
            }
        }
    }

    event VoteSuccess(string);

    //投票
    function vote(uint256 _targetId) public {
        Voter storage sender = voters[msg.sender];
        require(sender.amount != 0, "has no right to vote.");
        require(!sender.isvoted, "Already voted");

        sender.isvoted = true;
        sender.tagretId = _targetId;

        bords[_targetId].totalAmount += sender.amount;
        emit VoteSuccess(unicode"投票成功");
    }

    function delegator(address _delegator) public {
        Voter storage sender = voters[msg.sender];
        require(sender.amount != 0, unicode"没有投票权限");
        require(!sender.isvoted, unicode"你已经投过票了");
        require(msg.sender != _delegator, unicode"不能委托给自己");

        while (voters[_delegator].delegator != address(0)) {
            _delegator = voters[_delegator].delegator;
            require(_delegator == msg.sender, unicode"不能循环委托。");
        }

        sender.delegator = _delegator;
        sender.isvoted = true;

        Voter storage existsDelegator = voters[_delegator];
        if (existsDelegator.isvoted) {
            bords[existsDelegator.tagretId].totalAmount += sender.amount;
        } else {
            existsDelegator.amount += sender.amount;
        }
    }
}

//["刘能","赵四","谢广坤"]
//["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
//
//
//0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678
//["0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678"]