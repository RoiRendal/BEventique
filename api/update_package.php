<?php
// Allow CORS for development; adjust for production
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) header("Access-Control-Allow-Origin: {$origin}");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=utf-8");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

$dbFile = __DIR__ . '/db.php';
if (!file_exists($dbFile)) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'DB config missing']);
    exit;
}
include $dbFile;

$id = $_POST['id'] ?? null;
if (!$id) {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>'id required']);
    exit;
}

$Package_Name = $_POST['Package_Name'] ?? null;
$Description = $_POST['Description'] ?? null;

$NumTables = isset($_POST['NumTables']) ? (int)$_POST['NumTables'] : null;
$NumRoundTables = isset($_POST['NumRoundTables']) ? (int)$_POST['NumRoundTables'] : null;

$NumChairs = isset($_POST['NumChairs']) ? (int)$_POST['NumChairs'] : null;
$NumTent = isset($_POST['NumTent']) ? (int)$_POST['NumTent'] : null;
$NumPlatform = isset($_POST['NumPlatform']) ? (int)$_POST['NumPlatform'] : null;

$Package_Amount = $_POST['Package_Amount'] ?? null;

try {
    // handle file upload if provided
    $newPhotoUrl = null;
    if (!empty($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {

        $uploadDir = __DIR__ . '/uploads';
        if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);

        $pkgDir = $uploadDir . '/package_' . preg_replace('/[^0-9A-Za-z_-]/', '', $id);
        if (!is_dir($pkgDir)) mkdir($pkgDir, 0755, true);

        $tmp = $_FILES['photo']['tmp_name'];
        $name = basename($_FILES['photo']['name']);
        $ext = pathinfo($name, PATHINFO_EXTENSION);

        $filename = uniqid('p_') . ($ext ? '.' . $ext : '');
        $dest = $pkgDir . '/' . $filename;

        if (!move_uploaded_file($tmp, $dest)) {
            throw new Exception('Could not move uploaded file');
        }

        $newPhotoUrl = '/Eventique/api/uploads/package_' . $id . '/' . $filename;

        // insert into package_photos table
        try {
            $stmt = $pdo->prepare("INSERT INTO package_photos (package_id, photo_url) VALUES (?, ?)");
            $stmt->execute([$id, $newPhotoUrl]);
        } catch (Exception $e) {}

        // update main package table image
        try {
            $u = $pdo->prepare("UPDATE package SET image = ? WHERE Package_ID = ?");
            $u->execute([$newPhotoUrl, $id]);
        } catch (Exception $e) {}
    }

    // update other fields including NumRoundTables
    $sql = "UPDATE package SET
              Package_Name = COALESCE(?, Package_Name),
              Description = COALESCE(?, Description),
              NumTables = COALESCE(?, NumTables),
              NumRoundTables = COALESCE(?, NumRoundTables),
              NumChairs = COALESCE(?, NumChairs),
              NumTent = COALESCE(?, NumTent),
              NumPlatform = COALESCE(?, NumPlatform),
              Package_Amount = COALESCE(?, Package_Amount),
              updated_at = NOW()
            WHERE Package_ID = ?";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $Package_Name,
        $Description,
        $NumTables,
        $NumRoundTables,
        $NumChairs,
        $NumTent,
        $NumPlatform,
        $Package_Amount,
        $id
    ]);

    echo json_encode(['status'=>'success','photo'=>$newPhotoUrl]);
    exit;

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status'=>'error',
        'message'=>'Server error updating package',
        'detail'=>$e->getMessage()
    ]);
    exit;
}
?>
