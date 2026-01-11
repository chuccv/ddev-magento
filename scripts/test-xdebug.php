#!/usr/bin/env php
<?php

echo "=== Xdebug CLI Test ===\n\n";

echo "1. Checking if Xdebug extension is loaded:\n";
if (extension_loaded('xdebug')) {
    echo "   ✓ Xdebug is loaded\n";
} else {
    echo "   ✗ Xdebug is NOT loaded\n";
    exit(1);
}

echo "\n2. Xdebug version:\n";
if (function_exists('xdebug_info')) {
    echo "   " . xdebug_info('version') . "\n";
} else {
    $version = phpversion('xdebug');
    echo "   Version: $version\n";
}

echo "\n3. Xdebug configuration:\n";
$configs = [
    'xdebug.mode',
    'xdebug.client_host',
    'xdebug.client_port',
    'xdebug.idekey',
    'xdebug.start_with_request',
    'xdebug.log',
];

foreach ($configs as $config) {
    $value = ini_get($config);
    if ($value !== false && $value !== '') {
        echo "   $config = $value\n";
    }
}

echo "\n4. Testing Xdebug functions:\n";
if (function_exists('xdebug_break')) {
    echo "   ✓ xdebug_break() is available\n";
} else {
    echo "   ✗ xdebug_break() is NOT available\n";
}

if (function_exists('xdebug_info')) {
    echo "   ✓ xdebug_info() is available\n";
} else {
    echo "   ✗ xdebug_info() is NOT available\n";
}

echo "\n5. Testing breakpoint (if IDE is listening):\n";
echo "   Setting a breakpoint here...\n";
if (function_exists('xdebug_break')) {
    xdebug_break();
    echo "   ✓ Breakpoint triggered (if IDE connected)\n";
} else {
    echo "   ✗ Cannot trigger breakpoint\n";
}

echo "\n6. Test variable inspection:\n";
$testVar = "Hello Xdebug";
$testArray = ['key1' => 'value1', 'key2' => 'value2'];
$testObject = (object)['property' => 'value'];

echo "   Variables set for inspection:\n";
echo "   - \$testVar = $testVar\n";
echo "   - \$testArray = " . print_r($testArray, true);
echo "   - \$testObject = " . print_r($testObject, true);

echo "\n=== Test Complete ===\n";
echo "\nTo debug this script:\n";
echo "1. Enable Xdebug: ddev xdebug on\n";
echo "2. Set breakpoints in your IDE\n";
echo "3. Run: ddev exec php scripts/test-xdebug.php\n";
echo "4. Or run with debugger: ddev exec php -dxdebug.start_with_request=yes scripts/test-xdebug.php\n";
