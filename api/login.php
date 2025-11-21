<?php
// Allow CORS for development — replace or restrict origin in production
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) {
    header("Access-Control-Allow-Origin: $origin");
    header("Access-Control-Allow-Credentials: true");
} else {
    header("Access-Control-Allow-Origin: *");
}
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

// Read input
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) $input = $_POST;

$email = isset($input['email']) ? trim($input['email']) : '';
$password = isset($input['password']) ? $input['password'] : '';

if (!$email || !$password) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Missing email or password']);
    exit;
}

// include PDO connection
$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database config missing']);
    exit;
}
include $dbFile;

try {
    // Try common table/column names
    $queries = [
        "SELECT * FROM account WHERE Email = ? LIMIT 1",
        "SELECT * FROM accounts WHERE email = ? LIMIT 1",
        "SELECT * FROM `account` WHERE Email = ? LIMIT 1",
        "SELECT * FROM `accounts` WHERE email = ? LIMIT 1"
    ];

    $user = null;
    foreach ($queries as $sql) {
        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute([$email]);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($row) { $user = $row; break; }
        } catch (Exception $e) {
            // try next
        }
    }

    if (!$user) {
        http_response_code(401);
        echo json_encode(['status' => 'error', 'message' => 'Invalid credentials']);
        exit;
    }

    // find hash column
    $hash = $user['Hash'] ?? $user['password'] ?? $user['pass'] ?? $user['passwd'] ?? null;
    if (!$hash) {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'Server error: password field not found']);
        exit;
    }

    if (!password_verify($password, $hash)) {
        http_response_code(401);
        echo json_encode(['status' => 'error', 'message' => 'Invalid credentials']);
        exit;
    }

    // success: start session and return safe user
    if (session_status() !== PHP_SESSION_ACTIVE) session_start();

    $safeUser = [
        'id' => $user['Account_ID'] ?? $user['id'] ?? $user['account_id'] ?? null,
        'email' => $user['Email'] ?? $user['email'] ?? null,
        'firstname' => $user['FirstName'] ?? $user['first_name'] ?? null,
        'lastname' => $user['LastName'] ?? $user['last_name'] ?? null,
        'role' => $user['Role'] ?? $user['role'] ?? 'customer'
    ];

    $_SESSION['user'] = $safeUser;
    $_SESSION['role'] = $safeUser['role'];

    echo json_encode(['status' => 'success', 'message' => 'Login successful', 'user' => $safeUser]);
    exit;

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Server error']);
    exit;
}
?>
