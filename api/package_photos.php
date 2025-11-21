<?php
// Allow CORS for development (adjust origin in production)
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) {
    header("Access-Control-Allow-Origin: {$origin}");
    header("Access-Control-Allow-Credentials: true");
} else {
    header("Access-Control-Allow-Origin: *");
}
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

$package_id = isset($_GET['package_id']) ? trim($_GET['package_id']) : '';
if ($package_id === '') {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'package_id is required']);
    exit;
}

$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database config not found']);
    exit;
}
include $dbFile;

try {
    // Query package_photos table for rows linked to the package_id
    // Adjust table name/column if your schema differs
    $sql = "SELECT * FROM `package_photos` WHERE package_id = ? ORDER BY id ASC";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$package_id]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$rows) {
        // return empty array rather than 404 so frontend can gracefully handle no images
        echo json_encode(['status' => 'success', 'photos' => []]);
        exit;
    }

    $photos = [];
    foreach ($rows as $r) {
        // prefer common column names; allow flexibility
        $candidates = ['photo', 'photo_url', 'url', 'image', 'file', 'path', 'src'];
        $found = null;
        foreach ($candidates as $col) {
            if (isset($r[$col]) && trim((string)$r[$col]) !== '') {
                $found = trim((string)$r[$col]);
                break;
            }
        }
        // if no column matched, check first non-empty column value
        if ($found === null) {
            foreach ($r as $val) {
                if (is_string($val) && trim($val) !== '') {
                    $found = trim($val);
                    break;
                }
            }
        }
        if ($found !== null) $photos[] = $found;
    }

    echo json_encode(['status' => 'success', 'photos' => $photos]);
    exit;

} catch (Exception $e) {
    http_response_code(500);
    // In development you may include $e->getMessage() for debugging
    echo json_encode(['status' => 'error', 'message' => 'Server error retrieving package photos']);
    exit;
}
?>
