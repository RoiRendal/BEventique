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

$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database config not found']);
    exit;
}
include $dbFile;

try {
    // Adjust table/column names if your schema differs
    $sql = "SELECT * FROM `package`";
    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $out = [];
    foreach ($rows as $r) {
        $out[] = [
            'id' => $r['id'] ?? $r['Package_ID'] ?? $r['package_id'] ?? null,
            'Package_Name' => $r['Package_Name'] ?? $r['PackageName'] ?? $r['name'] ?? $r['package_name'] ?? null,
            'name' => $r['Package_Name'] ?? $r['PackageName'] ?? $r['name'] ?? null,
            'description' => $r['description'] ?? $r['Description'] ?? null,
            'NumTables' => isset($r['NumTables']) ? (int)$r['NumTables'] : (isset($r['num_tables']) ? (int)$r['num_tables'] : 0),
            'NumChairs' => isset($r['NumChairs']) ? (int)$r['NumChairs'] : (isset($r['num_chairs']) ? (int)$r['num_chairs'] : 0),
            'NumTent' => isset($r['NumTent']) ? (int)$r['NumTent'] : (isset($r['num_tent']) ? (int)$r['num_tent'] : 0),
            'NumPlatform' => isset($r['NumPlatform']) ? (int)$r['NumPlatform'] : (isset($r['num_platform']) ? (int)$r['num_platform'] : 0),
            'Package_Amount' => isset($r['Package_Amount']) ? $r['Package_Amount'] : (isset($r['price_from']) ? $r['price_from'] : null),
            'price_from' => isset($r['price_from']) ? $r['price_from'] : null,
            'price_to' => isset($r['price_to']) ? $r['price_to'] : null,
            // photos normalization (existing logic)
            'photos' => (function($r) {
                $photosRaw = $r['package_photos'] ?? $r['photos'] ?? $r['images'] ?? $r['image'] ?? $r['image_url'] ?? null;
                $photos = [];
                if ($photosRaw) {
                    $maybeJson = json_decode($photosRaw, true);
                    if (is_array($maybeJson)) {
                        foreach ($maybeJson as $p) { $p = trim((string)$p); if ($p !== '') $photos[] = $p; }
                    } else {
                        $parts = array_map('trim', explode(',', $photosRaw));
                        foreach ($parts as $p) { if ($p !== '') $photos[] = $p; }
                    }
                }
                if (empty($photos)) {
                    $fallbackImage = $r['image'] ?? $r['image_url'] ?? null;
                    if ($fallbackImage) $photos[] = $fallbackImage;
                }
                return $photos;
            })($r),
            'image' => null, // client can use photos[0]
            'status' => $r['status'] ?? null,
        ];
    }

    echo json_encode(['status' => 'success', 'packages' => $out]);
    exit;
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Server error']);
    exit;
}
?>
