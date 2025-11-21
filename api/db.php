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
    // Set error flag for parent script to handle
    $dbConnectionError = [
        "status" => "error",
        "message" => "Database connection failed. Please verify database name and credentials.",
        "detail" => $lastException ? $lastException->getMessage() : null
    ];
}

// $pdo is available for inclusion by other scripts
?>