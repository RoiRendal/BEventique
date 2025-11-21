<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=utf-8");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }
$input = json_decode(file_get_contents('php://input'), true);
if (!$input || (empty($input['photo_id']) && empty($input['photo_url']))) {
    http_response_code(400); echo json_encode(['status'=>'error','message'=>'photo_id or photo_url required']); exit;
}
include __DIR__ . '/db.php';
try {
    if (!empty($input['photo_id'])) {
        $stmt = $pdo->prepare("SELECT photo_url FROM package_photos WHERE id = ? LIMIT 1");
        $stmt->execute([$input['photo_id']]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $photoUrl = $row['photo_url'] ?? null;
        $stmt = $pdo->prepare("DELETE FROM package_photos WHERE id = ?");
        $stmt->execute([$input['photo_id']]);
    } else {
        $photoUrl = $input['photo_url'];
        $stmt = $pdo->prepare("DELETE FROM package_photos WHERE photo_url = ? LIMIT 1");
        $stmt->execute([$photoUrl]);
    }
    // remove file from disk if it is relative
    if ($photoUrl && strpos($photoUrl, '/') === 0) {
        $path = $_SERVER['DOCUMENT_ROOT'] . $photoUrl;
        if (file_exists($path)) @unlink($path);
    }
    echo json_encode(['status'=>'success']);
    exit;
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>'Could not delete photo']);
    exit;
}
?>
