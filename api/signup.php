<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}

$input = json_decode(file_get_contents("php://input"), true);

$first = trim($input["first_name"] ?? "");
$middle = trim($input["middle_initial"] ?? "");
$last = trim($input["last_name"] ?? "");
$email = trim($input["email"] ?? "");
$password = $input["password"] ?? "";
$phone = trim($input["phone"] ?? "");

if (!$first || !$last || !$email || !$password) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

include __DIR__ . "/db.php";

// hash password
$hashed = password_hash($password, PASSWORD_DEFAULT);

try {
    // Check if email exists
    $check = $pdo->prepare("SELECT Email FROM account WHERE Email = ?");
    $check->execute([$email]);

    if ($check->rowCount() > 0) {
        echo json_encode(["status" => "error", "message" => "Email already registered"]);
        exit;
    }

    // Insert new account
    $stmt = $pdo->prepare("
        INSERT INTO account (Email, Hash, FirstName, LastName, M_I, PhoneNumber, Role)
        VALUES (?, ?, ?, ?, ?, ?, 'customer')
    ");

    $stmt->execute([$email, $hashed, $first, $last, $middle, $phone]);

    echo json_encode(["status" => "success", "message" => "Account created"]);
    exit;

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => "Server error"]);
    exit;
}
?>
