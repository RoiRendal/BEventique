<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

if (empty($_POST['package_id'])) {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>'package_id required']);
    exit;
}
$package_id = $_POST['package_id'];

if (empty($_FILES['photo'])) {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>'No file uploaded']);
    exit;
}

$u = __DIR__ . '/uploads';
if (!is_dir($u)) mkdir($u, 0755, true);
$pkgDir = $u . '/package_' . preg_replace('/[^0-9A-Za-z_-]/', '', $package_id);
if (!is_dir($pkgDir)) mkdir($pkgDir, 0755, true);

$file = $_FILES['photo'];
$ext = pathinfo($file['name'], PATHINFO_EXTENSION);
$fname = uniqid('photo_') . ($ext ? '.' . $ext : '');
$dest = $pkgDir . '/' . $fname;
if (!move_uploaded_file($file['tmp_name'], $dest)) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Upload failed']);
    exit;
}

// store record in package_photos table
include __DIR__ . '/db.php';
try {
    $urlPath = '/Eventique/api/uploads/package_' . preg_replace('/[^0-9A-Za-z_-]/', '', $package_id) . '/' . $fname;
    $sql = "INSERT INTO package_photos (package_id, photo_url) VALUES (?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$package_id, $urlPath]);
    $id = $pdo->lastInsertId();
    echo json_encode(['status'=>'success','photo'=>['id'=>$id,'url'=>$urlPath]]);
    exit;
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Could not save photo record']);
    exit;
}
?>
