// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 amount;
        uint256 deadline;
        uint256[] donations;
        uint256 amountCollection;
        string img;
        address[] donators;
    }
    mapping(uint256=>Campaign) public campaigns;
    uint256 public numberOfcampaigns = 0;

    function createCampaign(address _owner,string memory _title,string memory _description,uint256 _target,uint256 _deadline,string memory _image)public returns(uint256){
        Campaign storage campaign = campaigns[numberOfcampaigns];
        require(campaign.deadline < block.timestamp, "The deadline cannot be previous to present day!");

        campaign.owner = _owner; 
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amount = 0;
        campaign.img = _image;

        numberOfcampaigns++;

        return numberOfcampaigns-1;
    }
    function donateInCampaign(uint256 _id)public payable{
        uint256 amount  = msg.value;
        Campaign storage campaign =  campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");
         if(sent){
            campaign.amountCollection = campaign.amountCollection + amount;
         }
        
    }
    function getDonators(uint256 _id) view public returns(address[] memory,uint256[] memory){
        return(campaigns[_id].donators,campaigns[_id].donations);
    }
    function getCampaigns()public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfcampaigns);

        for(uint i =0;i<numberOfcampaigns;i++){
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}