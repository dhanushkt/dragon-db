<?php
require '../mkvrename_creds.php';
// URL of the raw file from GitHub
$githubUrl = $creds_local_sync_url;
// Path to the local file
$localFilePath = __DIR__ . '/../mkvrename_api.php';

echo "GitHub URL : " . $githubUrl . "\n";
echo "Local File Path : " . $localFilePath . "\n";

// Function to fetch the content from GitHub
function fetchFromGitHub($url)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

// Fetch the content from GitHub
$content = fetchFromGitHub($githubUrl);

if ($content === false) {
    echo "Failed to fetch content from GitHub.";
} else {
    // Write the content to the local file
    if (file_put_contents($localFilePath, $content) !== false) {
        echo "File `mkvrename_api.php` synced from GitHub.";
    } else {
        echo "Failed to Sync the file.";
    }
}