<?php

$string = file_get_contents('account_names_pre.txt');

$start = 0;
$servers = [];
do {
    $newlinePos = strpos($string, "\n", $start);
    if ($newlinePos >= 0) {
        $line = substr($string, $start, $newlinePos - $start);
    } else {
        $line = substr($string, $start);
    }
    if ($line != '') {
        $servers[] = $line;
    }
    $start = $newlinePos + 1;
} while (!empty(trim($line)));

$results = [];

do {
    $newlinePos = strpos($string, "\n", $start);
    if ($newlinePos >= 0) {
        $line = substr($string, $start, $newlinePos - $start);
    } else {
        $line = substr($string, $start);
    }
    if ($line != '') {
        $results[] = '@' . $line . '@' . $servers[rand(0, count($servers) - 1)];
        #error_log($results[count($results) - 1]);
    }
    
    $start = $newlinePos + 1;
} while (!empty(trim($line)) && $newlinePos > 0);

$content = '';
foreach ($results as $account) {
    $content .= $account . "\n";
}

file_put_contents('account_names_new.txt', $content);