// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    //object  for each campagin          
  struct Campaign{
    address owner;
    string title;
    string description;
    uint256 target;
    uint256 deadline;
    uint256 amountcollected;
    string image;
     address[] donators;
     uint256[] donations;
    }
    mapping(uint256=>Campaign)public campagins;
    uint256 public numberOfCampaigns=0;
    function createCampaign(address _owner,string memory _title,string memory _description,uint256 _target,uint256 _deadline,string memory _image) public returns(uint256) {
        Campaign storage campagin=campagins[numberOfCampaigns];
        //check deadline errot
        require(campagin.deadline<block.timestamp,  "The Deadline should be a date in the future");
        
        campagin.owner=_owner;
        campagin.title=_title;
        campagin.description=_description;
        campagin.target=_target;
        campagin.deadline=_deadline;
        campagin.amountcollected=0;

        numberOfCampaigns++;
        return numberOfCampaigns-1;

    }
    function donateToCampaign(uint256 _id)public payable {
        uint256 amount=msg.value;
        Campaign storage campagin=campagins[_id];
        campagin.donators.push(msg.sender);
        campagin.donations.push(amount);
        (bool sent,)=payable(campagin.owner).call{value:amount}("");

        if(sent){
            campagin.amountcollected=campagin.amountcollected+amount;
        }


    }
    function getDonators(uint256 _id) view public returns(address[] memory,uint256[] memory){
        return (campagins[_id].donators,campagins[_id].donations);

    }
    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i=0;i<numberOfCampaigns;i++){
            Campaign storage item=campagins[i];
            allCampaigns[i]=item;
    }
    return allCampaigns;
    }
}