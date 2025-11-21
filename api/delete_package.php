<?php
// Allow CORS for development; adjust for production
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) {
    header("Access-Control-Allow-Origin: {$origin}");
    header("Access-Control-Allow-Credentials: true");
} else {
    header("Access-Control-Allow-Origin: *");
}
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status'=>'error','message'=>'Method not allowed']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
if (!$input || empty($input['id'])) {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>'id required']);
    exit;
}

$id = $input['id'];

$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Database config missing']);
    exit;
}
include $dbFile;

try {
    // Try to determine the correct primary key column name
    // Common variations: id, package_id, Package_ID
    $pkColumn = 'id'; // default
    
    // Check which column exists in the package table
    try {
        $checkStmt = $pdo->query("SHOW COLUMNS FROM `package` WHERE Field IN ('id', 'package_id', 'Package_ID')");
        $cols = $checkStmt->fetchAll(PDO::FETCH_COLUMN);
        if (in_array('Package_ID', $cols)) {
            $pkColumn = 'Package_ID';
        } elseif (in_array('package_id', $cols)) {
            $pkColumn = 'package_id';
        }
    } catch (Exception $e) {
        // If package table doesn't exist, try packages
        try {
            $checkStmt = $pdo->query("SHOW COLUMNS FROM `packages` WHERE Field IN ('id', 'package_id', 'Package_ID')");
            $cols = $checkStmt->fetchAll(PDO::FETCH_COLUMN);
            if (in_array('Package_ID', $cols)) {
                $pkColumn = 'Package_ID';
            } elseif (in_array('package_id', $cols)) {
                $pkColumn = 'package_id';
            }
        } catch (Exception $e2) {
            // fallback to default
        }
    }

    // Optional: delete associated photos from package_photos table and filesystem
    try {
        $stmt = $pdo->prepare("SELECT photo_url FROM package_photos WHERE package_id = ?");
        $stmt->execute([$id]);
        $photoRows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($photoRows as $pr) {
            $photoUrl = $pr['photo_url'] ?? null;
            if ($photoUrl && strpos($photoUrl, '/') === 0) {
                $path = $_SERVER['DOCUMENT_ROOT'] . $photoUrl;
                if (file_exists($path)) @unlink($path);
            }
        }
        $delStmt = $pdo->prepare("DELETE FROM package_photos WHERE package_id = ?");
        $delStmt->execute([$id]);
    } catch (Exception $e) {
        // ignore if table missing
    }

    // Delete the package row - try both table names
    $deleted = false;
    foreach (['package', 'packages'] as $tableName) {
        try {
            $sql = "DELETE FROM `{$tableName}` WHERE `{$pkColumn}` = ? LIMIT 1";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([$id]);
            
            if ($stmt->rowCount() > 0) {
                $deleted = true;
                break;
            }
        } catch (Exception $e) {
            // try next table name
            continue;
        }
    }

    if (!$deleted) {
        http_response_code(404);
        echo json_encode(['status'=>'error','message'=>'Package not found or already deleted','attempted_column'=>$pkColumn]);
        exit;
    }

    echo json_encode(['status'=>'success','message'=>'Package deleted']);
    exit;
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Server error deleting package','detail'=>$e->getMessage()]);
    exit;
}
?>
