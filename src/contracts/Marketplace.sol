pragma solidity ^0.5.0;

contract Marketplace {
 string public name;
   uint public productCount = 0;
    mapping(uint => Product) public products;

   struct Product {
    uint id;
    string name;
    uint price;
    address owner;
    bool purchased;
    bool deleted;
}   
     event ProductCreated(
        uint id,
        string name,
        uint price,
        address owner,
        bool purchased,
        bool deleted
    );
    event ProductPurchased(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased,
    bool deleted
);
event ProductDeleted(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased,
     bool deleted
);

 constructor() public {
        name = "Ritik Rawat Marketplace";
    }
 function createProduct(string memory _name, uint _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product count
        productCount++;
        // Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false,false);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false,false);
    }

  function deleteProduct(uint _id) public {
       Product memory _product = products[_id];
    // Fetch the owner
    address payable _seller = address(uint160(_product.owner));
    // Make sure the product has a valid id
    require(_product.id > 0 && _product.id <= productCount);
    // Require that the buyer is the seller
    require(_seller == msg.sender);
    _product.deleted=true;
    // Update the product
    products[_id] = _product;
    // Trigger an event
    emit ProductDeleted(productCount, _product.name, _product.price, msg.sender, false,true);
    }
  

    function purchaseProduct(uint _id) public payable {
    // Fetch the product
    Product memory _product = products[_id];
    // Fetch the owner
    address payable _seller = address(uint160(_product.owner));
    // Make sure the product has a valid id
    require(_product.id > 0 && _product.id <= productCount);
    // Require that there is enough Ether in the transaction
    require(msg.value >= _product.price);
    // Require that the product has not been purchased already
    require(!_product.purchased);
    // Require that the buyer is not the seller
    require(_seller != msg.sender);
    // Transfer ownership to the buyer
    _product.owner = msg.sender;
    // Mark as purchased
    _product.purchased = true;
    // Update the product
    products[_id] = _product;
    // Pay the seller by sending them Ether
    address(_seller).transfer(msg.value);
    // Trigger an event
    emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true, false);
}
}