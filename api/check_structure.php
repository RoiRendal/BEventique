<?php
header("Content-Type: application/json");

include __DIR__ . '/db.php';

try {
    $stmt = $pdo->query("DESCRIBE package");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'columns' => $columns
    ], JSON_PRETTY_PRINT);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
