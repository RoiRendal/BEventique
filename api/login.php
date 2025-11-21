<?php
header("Access-Control-Allow-Origin: http://localhost:3000");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$input = json_decode(file_get_contents("php://input"), true);

$email = trim($input["email"] ?? "");
$password = $input["password"] ?? "";

if (!$email || !$password) {
    echo json_encode(["status" => "error", "message" => "Missing email or password"]);
    exit;
}

include __DIR__ . "/db.php";

try {
    $stmt = $pdo->prepare("SELECT * FROM account WHERE Email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($password, $user["Hash"])) {

        echo json_encode([
            "status" => "success",
            "user" => [
                "id"        => $user["Account_ID"],
                "email"     => $user["Email"],
                "firstname" => $user["FirstName"],
                "lastname"  => $user["LastName"],
                "role"      => $user["Role"]
            ]
        ]);
        exit;

    } else {
        echo json_encode(["status" => "error", "message" => "Invalid email or password"]);
        exit;
    }

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => "Server error"]);
    exit;
}
