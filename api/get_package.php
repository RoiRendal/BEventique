<?php
// Allow CORS for development; restrict in production
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) {
    header("Access-Control-Allow-Origin: {$origin}");
    header("Access-Control-Allow-Credentials: true");
} else {
    header("Access-Control-Allow-Origin: *");
}
header("Content-Type: application/json; charset=utf-8");

// Check ID
if (!isset($_GET['id']) || trim($_GET['id']) === '') {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>'id required']);
    exit;
}

$id = $_GET['id'];

// Load DB
$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Database config not found']);
    exit;
}
include $dbFile;

try {

    // FIXED — must use Package_ID
    $sql = "SELECT * FROM package WHERE Package_ID = ? LIMIT 1";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        http_response_code(404);
        echo json_encode(['status'=>'error','message'=>'Package not found']);
        exit;
    }

    // normalize photos (optional)
    $photos = [];
    $photosRaw = $row['package_photos'] ?? $row['photos'] ?? $row['images'] ?? $row['image'] ?? null;
    
    if ($photosRaw) {
        $decoded = json_decode($photosRaw, true);
        if (is_array($decoded)) {
            foreach ($decoded as $p) {
                $p = trim((string)$p);
                if ($p !== '') $photos[] = $p;
            }
        } else {
            foreach (array_map('trim', explode(',', $photosRaw)) as $p) {
                if ($p !== '') $photos[] = $p;
            }
        }
    }

    if (empty($photos) && !empty($row['image'])) {
        $photos[] = $row['image'];
    }

    // FINAL OUTPUT — NOW INCLUDES NumRoundTables
    $pkg = [
        'id'               => (int)$row['Package_ID'],
        'Package_Name'     => $row['Package_Name'],
        'Description'      => $row['Description'],
        'NumTables'        => (int)$row['NumTables'],
        'NumRoundTables'   => isset($row['NumRoundTables']) ? (int)$row['NumRoundTables'] : 0,
        'NumChairs'        => (int)$row['NumChairs'],
        'NumTent'          => (int)$row['NumTent'],
        'NumPlatform'      => (int)$row['NumPlatform'],
        'Package_Amount'   => $row['Package_Amount'],
        'photo'            => $photos[0] ?? null,
        'photos'           => $photos,
        'status'           => $row['Status'] ?? $row['status'] ?? null,
    ];

    echo json_encode(['status'=>'success','package'=>$pkg]);
    exit;

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Server error: '.$e->getMessage()]);
    exit;
}
?>
