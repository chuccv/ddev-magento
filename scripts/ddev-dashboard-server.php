<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_SERVER['REQUEST_URI'] === '/api/ddev-list') {
    $command = 'ddev list -j 2>&1';
    $output = shell_exec($command);
    
    if ($output === null) {
        echo json_encode(['error' => 'Failed to execute ddev list command']);
        exit;
    }
    
    $jsonStart = strpos($output, '{"level"');
    if ($jsonStart !== false) {
        $jsonString = substr($output, $jsonStart);
        $jsonEnd = strrpos($jsonString, '}');
        if ($jsonEnd !== false) {
            $jsonString = substr($jsonString, 0, $jsonEnd + 1);
            $data = json_decode($jsonString, true);
            if ($data && isset($data['raw'])) {
                echo json_encode(['raw' => $data['raw']]);
                exit;
            }
        }
    }
    
    echo json_encode(['error' => 'Failed to parse ddev list output', 'raw_output' => $output]);
    exit;
}

http_response_code(404);
echo json_encode(['error' => 'Not found']);
