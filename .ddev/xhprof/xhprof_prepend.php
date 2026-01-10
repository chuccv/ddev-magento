<?php

$phpProfilerAutoload = '/usr/local/xhgui.collector/php-profiler/autoload.php';
if (file_exists($phpProfilerAutoload)) {
    require_once $phpProfilerAutoload;
} else {
    error_log("php-profiler autoloader not found at: $phpProfilerAutoload");
}

$collector_php = "/usr/local/xhgui.collector/xhgui.collector.php";
if (file_exists($collector_php)) {
    require_once $collector_php;
} else {
    error_log("File '$collector_php' not found");
}
