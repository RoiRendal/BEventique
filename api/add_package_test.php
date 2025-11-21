<?php
header("Content-Type: application/json; charset=utf-8");
error_reporting(0);
ini_set('display_errors', 0);

include __DIR__ . '/db.php';

if (!$pdo) {
    echo json_encode(['status'=>'error','message'=>'DB connection failed']);
    exit;
}

// Test simple insert without package_layout
try {
    $sql = "INSERT INTO package (Package_Name, Status) VALUES (?, 'active')";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['Test Package ' . time()]);
    
    echo json_encode(['status'=>'success','message'=>'Test insert worked', 'id'=>$pdo->lastInsertId()]);
} catch (Exception $e) {
    echo json_encode(['status'=>'error','message'=>$e->getMessage()]);
}
?>
