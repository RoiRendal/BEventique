<?php
// Attempt to connect to the correct database name. Tries common names and returns JSON error on failure.
$dbHosts = [
    ['host' => 'localhost', 'db' => 'eventique', 'user' => 'root', 'pass' => ''],
    ['host' => 'localhost', 'db' => 'eventdb',    'user' => 'root', 'pass' => ''],
];

$pdo = null;
$lastException = null;

foreach ($dbHosts as $cfg) {
    try {
        $dsn = "mysql:host={$cfg['host']};dbname={$cfg['db']};charset=utf8mb4";
        $pdo = new PDO($dsn, $cfg['user'], $cfg['pass'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
        // success
        break;
    } catch (PDOException $e) {
        $lastException = $e;
        // try next
    }
}

if (!$pdo) {
    // Return JSON error instead of letting PHP emit an HTML fatal page
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed. Please verify database name and credentials.",
        "detail" => $lastException ? $lastException->getMessage() : null
    ]);
    exit;
}

// $pdo is available for inclusion by other scripts
?>