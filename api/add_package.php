<?php
// Absolutely no output before headers
ob_start();
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

// Allow CORS for development
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if ($origin) header("Access-Control-Allow-Origin: {$origin}");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    ob_end_clean();
    http_response_code(200);
    exit;
}

// Clear any buffer before processing
ob_end_clean();
ob_start();

try {
    // Include database
    $dbFile = __DIR__ . '/db.php';
    if (!file_exists($dbFile)) {
        throw new Exception('DB config missing');
    }
    
    require_once $dbFile;
    
    if (!isset($pdo) || !$pdo) {
        throw new Exception('Database connection failed');
    }

    // Get POST data
    $Package_Name = $_POST['Package_Name'] ?? null;
    $description = $_POST['description'] ?? '';
    $NumTables = isset($_POST['NumTables']) ? (int)$_POST['NumTables'] : 0;
    $NumRoundTables = isset($_POST['NumRoundTables']) ? (int)$_POST['NumRoundTables'] : 0;
    $NumChairs = isset($_POST['NumChairs']) ? (int)$_POST['NumChairs'] : 0;
    $NumTent = isset($_POST['NumTent']) ? (int)$_POST['NumTent'] : 0;
    $NumPlatform = isset($_POST['NumPlatform']) ? (int)$_POST['NumPlatform'] : 0;
    $Package_Amount = $_POST['Package_Amount'] ?? null;
    $canvas_layout = $_POST['canvas_layout'] ?? null;

    if (!$Package_Name) {
        throw new Exception('Package_Name required');
    }

    // Try to insert WITHOUT package_layout first
    $sql = "INSERT INTO package (Package_Name, Description, NumTables, NumRoundTables, NumChairs, NumTent, NumPlatform, Package_Amount, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $Package_Name,
        $description,
        $NumTables,
        $NumRoundTables,
        $NumChairs,
        $NumTent,
        $NumPlatform,
        $Package_Amount,
    ]);
    
    $newId = $pdo->lastInsertId();

    // Try to update with canvas_layout separately
    if ($canvas_layout && $newId) {
        try {
            $updateSql = "UPDATE package SET package_layout = ? WHERE Package_ID = ?";
            $updateStmt = $pdo->prepare($updateSql);
            $updateStmt->execute([$canvas_layout, $newId]);
        } catch (Exception $layoutError) {
            // Column doesn't exist, that's okay for now
            error_log("Canvas layout not saved: " . $layoutError->getMessage());
        }
    }

    // Handle photo uploads
    $photoUrls = [];
    $photoInsertCount = 0;
    $photoErrors = [];
    
    if (!empty($_FILES['photos'])) {
        $uploadDir = __DIR__ . '/uploads';
        if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);
        $pkgDir = $uploadDir . '/package_' . $newId;
        if (!is_dir($pkgDir)) mkdir($pkgDir, 0755, true);

        $fileCount = count($_FILES['photos']['name']);
        for ($i = 0; $i < $fileCount; $i++) {
            if ($_FILES['photos']['error'][$i] === UPLOAD_ERR_OK) {
                $tmp = $_FILES['photos']['tmp_name'][$i];
                $name = basename($_FILES['photos']['name'][$i]);
                $ext = pathinfo($name, PATHINFO_EXTENSION);
                $filename = uniqid('p_') . '_' . $i . ($ext ? '.' . $ext : '');
                $dest = $pkgDir . '/' . $filename;
                
                if (move_uploaded_file($tmp, $dest)) {
                    $photoUrl = '/Eventique/api/uploads/package_' . $newId . '/' . $filename;
                    $photoUrls[] = $photoUrl;
                    
                    // Insert into package_photos table - CRITICAL: This saves all photos
                    try {
                        // Verify table exists first
                        $checkTable = $pdo->query("SHOW TABLES LIKE 'package_photos'");
                        if ($checkTable->rowCount() > 0) {
                            $photoStmt = $pdo->prepare("INSERT INTO package_photos (Package_ID, Photo) VALUES (?, ?)");
                            $success = $photoStmt->execute([$newId, $photoUrl]);
                            if ($success) {
                                $photoInsertCount++;
                            } else {
                                $photoErrors[] = "Failed to insert photo: " . $photoUrl;
                            }
                        } else {
                            // Table doesn't exist - create it
                            $createTableSql = "CREATE TABLE IF NOT EXISTS package_photos (
                                Photo_ID INT AUTO_INCREMENT PRIMARY KEY,
                                Package_ID INT NOT NULL,
                                Photo VARCHAR(500) NOT NULL,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (Package_ID) REFERENCES package(Package_ID) ON DELETE CASCADE
                            )";
                            $pdo->exec($createTableSql);
                            
                            // Try insert again
                            $photoStmt = $pdo->prepare("INSERT INTO package_photos (Package_ID, Photo) VALUES (?, ?)");
                            if ($photoStmt->execute([$newId, $photoUrl])) {
                                $photoInsertCount++;
                            }
                        }
                    } catch (Exception $photoError) {
                        $photoErrors[] = $photoError->getMessage();
                        error_log("Photo insert error for package $newId: " . $photoError->getMessage());
                    }
                    
                    // Update main photo (first photo becomes the package thumbnail)
                    if ($i === 0) {
                        try {
                            $u = $pdo->prepare("UPDATE package SET Photo = ? WHERE Package_ID = ?");
                            $u->execute([$photoUrl, $newId]);
                        } catch (Exception $photoUpdateError) {
                            error_log("Photo update error: " . $photoUpdateError->getMessage());
                        }
                    }
                }
            }
        }
    }

    ob_end_clean();
    echo json_encode([
        'status'=>'success',
        'message'=>'Package created',
        'id'=>$newId,
        'photos'=>$photoUrls,
        'photos_in_db'=>$photoInsertCount,
        'photo_errors'=>$photoErrors
    ]);
    exit;

} catch (Exception $e) {
    ob_end_clean();
    http_response_code(500);
    echo json_encode(['status'=>'error','message'=>$e->getMessage()]);
    exit;
}
?>
