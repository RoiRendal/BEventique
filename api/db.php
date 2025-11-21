<?php
// Database connection using PDO. Adjust host/db/user/password as needed.
try {
	$pdo = new PDO("mysql:host=localhost;dbname=eventdb;charset=utf8mb4", "root", "");
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
	// In production, avoid echoing DB errors
	header('Content-Type: application/json');
	echo json_encode(["status" => "error", "message" => "Database connection failed"]);
	exit;
}
?>