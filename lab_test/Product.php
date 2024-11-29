<?php
include_once 'Database.php';

class Product {
    private $conn;
    private $table_name = "tblproduct";

    public $ProductName;
    public $Description;
    public $CategoryID;
    public $Barcode;
    public $ExpiredDate;
    public $Qty;
    public $UnitPriceIn;
    public $UnitPriceOut;
    public $ProductImage;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET ProductName=:ProductName, Description=:Description, CategoryID=:CategoryID, 
                      Barcode=:Barcode, ExpiredDate=:ExpiredDate, Qty=:Qty, 
                      UnitPriceIn=:UnitPriceIn, UnitPriceOut=:UnitPriceOut, ProductImage=:ProductImage";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":ProductName", $this->ProductName);
        $stmt->bindParam(":Description", $this->Description);
        $stmt->bindParam(":CategoryID", $this->CategoryID);
        $stmt->bindParam(":Barcode", $this->Barcode);
        $stmt->bindParam(":ExpiredDate", $this->ExpiredDate);
        $stmt->bindParam(":Qty", $this->Qty);
        $stmt->bindParam(":UnitPriceIn", $this->UnitPriceIn);
        $stmt->bindParam(":UnitPriceOut", $this->UnitPriceOut);
        $stmt->bindParam(":ProductImage", $this->ProductImage);

        if ($stmt->execute()) {
            return true;
        }
        return false;
    }
}
?>
