<?php
header("Content-Type: application/json; charset=UTF-8");
include_once 'Product.php';

$database = new Database();
$db = $database->getConnection();

$product = new Product($db);

$data = json_decode(file_get_contents("php://input"));

if (
    !empty($data->ProductName) &&
    !empty($data->CategoryID) &&
    !empty($data->Barcode) &&
    !empty($data->Qty) &&
    !empty($data->UnitPriceIn) &&
    !empty($data->UnitPriceOut)
) {
    $product->ProductName = $data->ProductName;
    $product->Description = $data->Description ?? null;
    $product->CategoryID = $data->CategoryID;
    $product->Barcode = $data->Barcode;
    $product->ExpiredDate = $data->ExpiredDate ?? null;
    $product->Qty = $data->Qty;
    $product->UnitPriceIn = $data->UnitPriceIn;
    $product->UnitPriceOut = $data->UnitPriceOut;
    $product->ProductImage = $data->ProductImage ?? "default.png";

    if ($product->create()) {
        echo json_encode(["message" => "Product added successfully."]);
    } else {
        echo json_encode(["message" => "Unable to add product."]);
    }
} else {
    echo json_encode(["message" => "Incomplete data."]);
}
?>
